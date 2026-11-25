using System.Reflection;
using Underanalyzer.Decompiler;
using UndertaleModLib;
using UndertaleModLib.Compiler;
using UndertaleModLib.Decompiler;
using UndertaleModLib.Models;
using UndertaleModLib.Util;

namespace DeltaTranslator;

internal static class GamePatch
{
    private const string Function = "scr_trigger_translation";
    private const string Script = "gml_GlobalScript_" + Function;
    private const string Marker = "__deltatranslator_patch_v16";
    private const string OverlayFont = "fnt_dt_overlay";
    private const string RussianOverlayFont = "fnt_dt_overlay_ru";
    private static readonly EventTarget[] Targets =
    [
        new("DEVICE_MENU", EventType.Draw, 0),
        new("obj_time", EventType.Draw, 64),
        new("obj_time", EventType.Other, 62),
        new("obj_time", EventType.Step, (uint)EventSubtypeStep.BeginStep),
        new("obj_time", EventType.Step, (uint)EventSubtypeStep.Step),
    ];

    // Only strip legacy code from these exact historical builds.
    private static readonly HashSet<string> LegacyInputs = new(StringComparer.OrdinalIgnoreCase)
    {
        "33ee69726da5aa1b5a5020bf05202136825d94730578120a28fc81fe7993d68b",
        "2c3f2abf08d82e9a275b203e8786591080857e593a787a7c7b8061ade02a14ba",
    };

    internal static bool Apply(UndertaleData data, string sha256, int? expectedChapter)
    {
        const string titlePrefix = "DELTARUNE Chapter ";
        var title = data.GeneralInfo?.DisplayName?.Content;
        if (title is null || !title.StartsWith(titlePrefix, StringComparison.Ordinal) ||
            !ChapterFiles.TryNumber(title[titlePrefix.Length..], out var chapter))
            throw new InvalidDataException("Expected a numbered DELTARUNE chapter data file.");
        if (expectedChapter is int expected && chapter != expected)
            throw new InvalidDataException($"Expected chapter {expected}, but found chapter {chapter}.");
        if (!data.IsVersionAtLeast(2, 3) || data.Code is null || data.GlobalInitScripts is null)
            throw new InvalidDataException("Only GameMaker 2.3+ bytecode archives are supported.");

        var context = new GlobalDecompileContext(data);
        if (data.Code.ByName(Script) is { } script)
        {
            if (script.Instructions.Any(i => i.ValueVariable?.Name.Content == Marker))
            {
                Verify(data, context);
                return false;
            }
            if (script.Instructions.Any(i => i.ValueVariable?.Name.Content is
                "__deltatranslator_patch_v1" or "__deltatranslator_patch_v2" or "__deltatranslator_patch_v3" or "__deltatranslator_patch_v4" or
                "__deltatranslator_patch_v5" or "__deltatranslator_patch_v6" or "__deltatranslator_patch_v7" or "__deltatranslator_patch_v8" or
                "__deltatranslator_patch_v9" or "__deltatranslator_patch_v10" or "__deltatranslator_patch_v11" or "__deltatranslator_patch_v12" or "__deltatranslator_patch_v13" or "__deltatranslator_patch_v14" or "__deltatranslator_patch_v15"))
                throw new InvalidDataException("An earlier DeltaTranslator is installed. Restore the original game archive from a matching backup or verify files in Steam, then install again.");
            throw new InvalidDataException($"A different mod already defines {Function}.");
        }
        if (context.GlobalFunctions.FunctionNameExists(Function))
            throw new InvalidDataException($"A different mod already defines {Function}.");

        foreach (var name in new[] { "obj_writer", "obj_choicer_neo", "obj_choicer_old", "obj_battlecontroller" })
            if (data.GameObjects.ByName(name) is null)
                throw new InvalidDataException($"Required object is missing: {name}.");
        foreach (var name in new[] { "snd_select", "snd_bell", "snd_cantselect", "snd_spearrise" })
            if (data.Sounds.ByName(name) is null)
                throw new InvalidDataException($"Required sound is missing: {name}.");
        if (data.Sprites.ByName("spr_pxwhite") is null || !context.GlobalFunctions.FunctionNameExists("snd_play"))
            throw new InvalidDataException("Required assets spr_pxwhite or snd_play are missing.");

        InstallFont(data, OverlayFont, "Determination (Cyrillic)", "");
        InstallFont(data, RussianOverlayFont, "Determination Mono (DubstepDude)", "-ru");
        var legacy = LegacyInputs.Contains(sha256);
        var import = new CodeImportGroup(data, context);
        import.QueueReplace(Script, $"global.{Marker} = true;\n" + ReadText($"Code.{Script}.gml"));
        foreach (var target in Targets)
        {
            var body = ReadText($"Code.{target.Name}.gml");
            var original = FindEvent(data, target);
            if (original is null)
            {
                if ((legacy && !target.IsBeginStep) || target.ObjectName == "DEVICE_MENU")
                    throw new InvalidDataException($"Required event is missing: {target.Name}.");
                // Creating by name registers both the CODE entry and the event action on obj_time.
                import.QueueReplace(target.Name, body);
            }
            else if (legacy && !target.IsBeginStep)
            {
                var source = new DecompileContext(context, original, import.DecompileSettings).DecompileToString();
                import.QueueReplace(original, RemoveKnownLegacy(target, source, chapter) + "\n" + body);
            }
            else
            {
                if (original.Instructions.Any(i => IsLegacySymbol(i.ValueVariable?.Name.Content) ||
                    IsLegacySymbol(i.ValueString?.Resource?.Content)))
                    throw new InvalidDataException($"Unknown translation patch in {target.Name}. Use an unmodified game file.");
                // Capture the picker before vanilla keyboard sampling, without skipping vanilla logic.
                if (target.IsBeginStep)
                    import.QueuePrepend(original, body);
                else
                    import.QueueAppend(original, body);
            }
        }

        // One group links the new script functions to both Step events.
        import.Import();
        Verify(data, context);
        return true;
    }

    internal static void Verify(UndertaleData data) => Verify(data, new GlobalDecompileContext(data));

    private static void Verify(UndertaleData data, GlobalDecompileContext context)
    {
        var script = data.Code.ByName(Script);
        var step = FindEvent(data, Targets[^1]);
        if (script is null || data.GlobalInitScripts.Count(init => init.Code == script) != 1 ||
            !script.Instructions.Any(i => i.ValueVariable?.Name.Content == Marker) ||
            !context.GlobalFunctions.TryGetFunction(Function, out var function) ||
            script.ChildEntries.SingleOrDefault(c => c.Name.Content == function.Name.Content) is not { Offset: > 0 } child ||
            data.Scripts.Count(s => s.Code == child) != 1 ||
            step is null || step.Instructions.Count(i => i.Kind == UndertaleInstruction.Opcode.Call &&
                ReferenceEquals(i.ValueFunction, function)) != 1)
            throw new InvalidDataException("The translation script is not linked to the Step event.");
        foreach (var target in Targets)
        {
            if (FindEvent(data, target) is not { Instructions.Count: > 0 } code)
                throw new InvalidDataException($"Missing compiled event: {target.Name}.");
            if (target.IsBeginStep && (!Calls("scr_dt_update_language_picker") || !Calls("scr_dt_consume_picker_keys")))
                throw new InvalidDataException("The picker input hooks are not linked to Begin Step.");

            bool Calls(string name) => context.GlobalFunctions.TryGetFunction(name, out var linked) &&
                code.Instructions.Count(i => i.Kind == UndertaleInstruction.Opcode.Call &&
                    ReferenceEquals(i.ValueFunction, linked)) == 1;
        }
        foreach (var fontName in new[] { OverlayFont, RussianOverlayFont })
            if (data.Fonts.ByName(fontName) is not { Texture: not null } font ||
                !RequiredOverlayGlyphs.All(ch => font.Glyphs.Any(g => g.Character == ch)))
                throw new InvalidDataException($"The translation font {fontName} is missing required glyphs.");
    }

    private static UndertaleCode? FindEvent(UndertaleData data, EventTarget target)
    {
        var obj = data.GameObjects.ByName(target.ObjectName) ??
            throw new InvalidDataException($"Required object is missing: {target.ObjectName}.");
        var events = obj.Events[(int)target.Type].Where(e => e.EventSubtype == target.Subtype).ToArray();
        var code = data.Code.ByName(target.Name);
        if ((events.Length == 0 || events is [{ Actions.Count: 0 }]) && code is null)
            return null;
        if (events is [{ Actions: [var action] }] && code is { ParentEntry: null } && action.CodeId == code)
            return code;
        throw new InvalidDataException($"Unexpected event linkage: {target.Name}.");
    }

    internal static string RemoveKnownLegacy(EventTarget target, string source, int chapter)
    {
        // These boundaries were checked against both exact input hashes above. Keep the original
        // instructions' decompiled GML, including Chapter 1's generated enum at the end of the menu.
        if (target.Type == EventType.Other || target.Type == EventType.Step && chapter == 1)
            return "";
        var boundary = target.ObjectName == "DEVICE_MENU"
            ? "\ndraw_set_font(fnt_main);\ndraw_set_halign(fa_left);\ndraw_set_valign(fa_top);\nvar box_x1 = 242;"
            : target.Type == EventType.Step ? "\nvar is_auto =" : "\nvar text_exists =";
        var index = source.IndexOf(boundary, StringComparison.Ordinal);
        if (index < 0 || source.LastIndexOf(boundary, StringComparison.Ordinal) != index)
            throw new InvalidDataException($"Cannot isolate legacy code in {target.Name}.");
        var enumIndex = source.IndexOf("\n\nenum e__VW\n", index, StringComparison.Ordinal);
        return source[..index] + (enumIndex < 0 ? "" : source[enumIndex..]);
    }

    private static bool IsLegacySymbol(string? name) => name is not null &&
        (name is "auto_translate" or "GOOGLE ПЕРЕВОДЧИК:" || name.StartsWith("trans_", StringComparison.Ordinal) ||
            name.StartsWith("https://translate.googleapis.com/", StringComparison.Ordinal));

    private const string RequiredOverlayGlyphs =
        "ÄÖÜäöüßẞÁÉÍÓÚÜÑáéíóúüñ¿¡ÀÂÃÇÊÔÕàâãçêôõ" +
        "ĄĆĘŁŃÓŚŹŻąćęłńóśźżҐЄІЇґєіїʼ₴ÇĞİÖŞÜçğış₺" +
        "ÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸàâæçéèêëîïôœùûüÿÌÒìò«»" +
        "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя";

    private static void InstallFont(UndertaleData data, string name, string displayName, string suffix)
    {
        var original = data.Fonts.ByName("fnt_main") ?? throw new InvalidDataException("Required font fnt_main is missing.");
        if (data.Fonts.ByName(name) is not null)
            throw new InvalidDataException($"A different mod already defines {name}.");

        using var png = OpenResource($"Fonts.overlay{suffix}.png");
        using var buffer = new MemoryStream();
        png.CopyTo(buffer);
        var image = GMImage.FromPng(buffer.ToArray(), verifyHeader: true);
        var width = checked((ushort)image.Width);
        var height = checked((ushort)image.Height);
        var page = new UndertaleEmbeddedTexture
        {
            Name = new UndertaleString($"Texture {data.EmbeddedTextures.Count}"),
            TextureWidth = width, TextureHeight = height, TextureData = new() { Image = image },
        };
        var item = new UndertaleTexturePageItem
        {
            SourceWidth = width, SourceHeight = height, TargetWidth = width, TargetHeight = height,
            BoundingWidth = width, BoundingHeight = height, TexturePage = page,
        };
        var glyphs = new UndertalePointerList<UndertaleFont.Glyph>();
        var rows = ReadText($"Fonts.glyphs{suffix}.csv").Split('\n', StringSplitOptions.TrimEntries);
        var metrics = rows[0].Split(';');
        foreach (var row in rows.Skip(1).Where(r => r.Length > 0))
        {
            var fields = row.Split(';');
            var g = new UndertaleFont.Glyph
            {
                Character = ushort.Parse(fields[0]), SourceX = ushort.Parse(fields[1]), SourceY = ushort.Parse(fields[2]),
                SourceWidth = ushort.Parse(fields[3]), SourceHeight = ushort.Parse(fields[4]),
                Shift = short.Parse(fields[5]), Offset = short.Parse(fields[6]),
            };
            if (g.SourceX + g.SourceWidth > width || g.SourceY + g.SourceHeight > height)
                throw new InvalidDataException("Translation font glyph is outside its atlas.");
            glyphs.Add(g);
        }
        // Use a separate asset so the game can load and draw its original font unchanged.
        var font = new UndertaleFont
        {
            Name = data.Strings.MakeString(name), DisplayName = data.Strings.MakeString(displayName),
            EmSizeIsFloat = true, EmSize = ushort.Parse(metrics[0]), Charset = original.Charset,
            Ascender = uint.Parse(metrics[1]), LineHeight = uint.Parse(metrics[2]),
            Texture = item, Glyphs = glyphs, RangeStart = glyphs.Min(g => g.Character), RangeEnd = glyphs.Max(g => g.Character),
        };
        if (original.Texture?.TexturePage.TextureInfo is { } group)
        {
            if (group.LoadType != UndertaleTextureGroupInfo.TextureGroupLoadType.InFile)
                throw new InvalidDataException("Installing the font into an external texture group is not supported.");
            page.TextureInfo = group;
            page.IndexInGroup = group.TexturePages.Count;
            group.TexturePages.Add(new() { Resource = page });
            group.Fonts.Add(new() { Resource = font });
        }
        data.EmbeddedTextures.Add(page);
        data.TexturePageItems.Add(item);
        data.Fonts.Add(font);
    }

    private static Stream OpenResource(string name) => Assembly.GetExecutingAssembly()
        .GetManifestResourceStream("DeltaTranslator." + name) ?? throw new InvalidDataException($"Missing resource: {name}.");

    private static string ReadText(string name)
    {
        using var reader = new StreamReader(OpenResource(name));
        return reader.ReadToEnd();
    }

    internal sealed record EventTarget(string ObjectName, EventType Type, uint Subtype)
    {
        internal string Name => $"gml_Object_{ObjectName}_{Type}_{Subtype}";
        internal bool IsBeginStep => Type == EventType.Step && Subtype == (uint)EventSubtypeStep.BeginStep;
    }
}
