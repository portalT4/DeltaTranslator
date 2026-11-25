using System.Security.Cryptography;
using DeltaTranslator;
using Underanalyzer.Decompiler;
using UndertaleModLib;
using UndertaleModLib.Compiler;
using UndertaleModLib.Decompiler;
using UndertaleModLib.Models;

if (args is ["--synthetic"])
{
    // Compile the real patch against empty named assets, without copying any game data.
    using var synthetic = UndertaleData.CreateNew();
    synthetic.SetGMS2Version(2024, 11, isLTS: false);
    synthetic.BuiltinList = new BuiltinList(synthetic);
    synthetic.GeneralInfo.DisplayName = synthetic.Strings.MakeString("DELTARUNE Chapter 5");
    foreach (var name in new[] { "DEVICE_MENU", "obj_time", "obj_writer", "obj_choicer_neo", "obj_choicer_old", "obj_battlecontroller", "obj_talkbubble" })
        synthetic.GameObjects.Add(new UndertaleGameObject { Name = synthetic.Strings.MakeString(name) });
    foreach (var name in new[] { "snd_select", "snd_bell", "snd_cantselect", "snd_spearrise" })
        synthetic.Sounds.Add(new UndertaleSound { Name = synthetic.Strings.MakeString(name) });
    synthetic.Sprites.Add(new UndertaleSprite { Name = synthetic.Strings.MakeString("spr_pxwhite") });
    synthetic.Fonts.Add(new UndertaleFont { Name = synthetic.Strings.MakeString("fnt_main") });
    var seed = new CodeImportGroup(synthetic, new GlobalDecompileContext(synthetic));
    seed.QueueReplace("gml_GlobalScript_snd_play", "function snd_play(_sound) { return 0; }");
    seed.QueueReplace("gml_Object_DEVICE_MENU_Draw_0", "draw_self();");
    var beginStep = new GamePatch.EventTarget("obj_time", EventType.Step, (uint)EventSubtypeStep.BeginStep);
    seed.QueueReplace(beginStep.Name, "global.test_game_accept = keyboard_check_pressed(vk_enter);");
    seed.Import();

    Check(GamePatch.Apply(synthetic, "", 5), "synthetic asset set must accept the patch");
    Check(synthetic.EmbeddedTextures.Count == 2, "both atlases must be linked");
    var beginSource = Decompile(new GlobalDecompileContext(synthetic), synthetic, beginStep);
    var capture = beginSource.IndexOf("scr_dt_update_language_picker();", StringComparison.Ordinal);
    var clear = beginSource.IndexOf("scr_dt_consume_picker_keys();", StringComparison.Ordinal);
    var vanilla = beginSource.IndexOf("global.test_game_accept = keyboard_check_pressed(", StringComparison.Ordinal);
    Check(capture >= 0 && clear > capture && vanilla > clear,
        "Begin Step must read picker keys, consume them, then let vanilla read input");
    Check(!GamePatch.Apply(synthetic, "", 5), "reapplying must be a no-op");
    Console.WriteLine("Synthetic archive: GML compilation, language picker, font assets and idempotence passed.");
    return;
}

var fixtures = args.Single();
for (var chapter = 1; chapter <= 2; chapter++)
{
    var file = Path.Combine(fixtures, $"data_ch{chapter}.win");
    using var input = File.OpenRead(file);
    var hash = Convert.ToHexString(SHA256.HashData(input));
    input.Position = 0;
    var data = UndertaleIO.Read(input);
    GamePatch.EventTarget[] events =
    [
        new("DEVICE_MENU", EventType.Draw, 0), new("obj_time", EventType.Draw, 64),
        new("obj_time", EventType.Other, 62), new("obj_time", EventType.Step, 0),
        new("obj_time", EventType.Step, (uint)EventSubtypeStep.BeginStep),
    ];
    var context = new GlobalDecompileContext(data);
    var original = events.Select(target => Decompile(context, data, target)).ToArray();
    Check(original.Any(string.IsNullOrEmpty), "the clean fixture should exercise event creation");
    var originalFont = data.Fonts.ByName("fnt_main");
    var originalGlyphs = originalFont.Glyphs.Select(g => g.Character).ToArray();
    var textureCount = data.EmbeddedTextures.Count;
    Check(GamePatch.Apply(data, hash, chapter), "first patch must change data");
    Check(data.EmbeddedTextures.Count == textureCount + 2, "both overlay font atlases should be embedded");
    Check(!GamePatch.Apply(data, "", chapter), "patch should be idempotent");
    using var output = new MemoryStream();
    UndertaleIO.Write(output, data);
    output.Position = 0;
    var saved = UndertaleIO.Read(output);
    GamePatch.Verify(saved);
    Check(saved.Fonts.ByName("fnt_main").Glyphs.Select(g => g.Character).SequenceEqual(originalGlyphs),
        "the game's normal font must remain unchanged");
    var defaultOverlay = saved.Fonts.ByName("fnt_dt_overlay");
    var russianOverlay = saved.Fonts.ByName("fnt_dt_overlay_ru");
    Check(defaultOverlay.Texture != saved.Fonts.ByName("fnt_main").Texture &&
        russianOverlay.Texture != saved.Fonts.ByName("fnt_main").Texture &&
        russianOverlay.Texture != defaultOverlay.Texture, "the overlays must use separate font textures");
    var decompiler = new GlobalDecompileContext(saved);
    for (var i = 0; i < events.Length; i++)
    {
        var prefix = original[i].Split("\n\nenum ", 2)[0].TrimEnd();
        var source = Decompile(decompiler, saved, events[i]);
        if (events[i].IsBeginStep)
        {
            var clear = source.IndexOf("scr_dt_consume_picker_keys();", StringComparison.Ordinal);
            Check(clear >= 0 && source.IndexOf(prefix, clear, StringComparison.Ordinal) >= clear,
                "the original Begin Step must run after keyboard capture");
        }
        else
        {
            Check(source.StartsWith(prefix + (prefix.Length == 0 ? "" : "\n"), StringComparison.Ordinal),
                $"original code must precede the patch: {events[i].Name}");
        }
    }
    Console.WriteLine($"Chapter {chapter}: clean archive, event creation, font and round-trip passed.");

    if (chapter == 1)
    {
        // Exercise the numbered chapter path without pretending to have a real Chapter 3 fixture.
        input.Position = 0;
        var numbered = UndertaleIO.Read(input);
        numbered.GeneralInfo.DisplayName = numbered.Strings.MakeString("DELTARUNE Chapter 3");
        Check(GamePatch.Apply(numbered, "", 3), "the patcher should not hardcode allowed chapter numbers");
    }
}

static string Decompile(GlobalDecompileContext context, UndertaleData data, GamePatch.EventTarget target) =>
    data.Code.ByName(target.Name) is { } code
        ? new DecompileContext(context, code, new DecompileSettings()).DecompileToString()
        : "";

static void Check(bool condition, string message)
{
    if (!condition) throw new InvalidOperationException(message);
}
