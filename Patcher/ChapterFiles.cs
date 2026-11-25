using System.Globalization;
using System.Text.RegularExpressions;

namespace DeltaTranslator;

internal static class ChapterFiles
{
    private static readonly Regex ChapterDirectory = new(@"\Achapter([1-9][0-9]*)(?:_windows)?\z", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
    private static readonly Regex MacChapterDirectory = new(@"\Achapter([1-9][0-9]*)_mac\z", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
    private static readonly Regex ChapterFile = new(@"\Adata_ch([1-9][0-9]*)\.win\z", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

    internal static bool TryNumber(string text, out int number) =>
        int.TryParse(text, NumberStyles.None, CultureInfo.InvariantCulture, out number) && number > 0;

    internal static SortedDictionary<int, List<string>> Discover(string root)
    {
        var folder = new DirectoryInfo(root);
        if (!folder.Exists) throw new DirectoryNotFoundException($"Game folder not found: {root}.");
        var chapters = new SortedDictionary<int, List<string>>();
        Scan(folder);
        var bundle = folder.Name.EndsWith(".app", StringComparison.OrdinalIgnoreCase)
            ? folder.FullName : Path.Combine(folder.FullName, "DELTARUNE.app");
        var resources = new DirectoryInfo(Path.Combine(bundle, "Contents", "Resources"));
        if (resources.Exists) Scan(resources);
        return chapters;

        void Scan(DirectoryInfo directoryRoot)
        {
            foreach (var directory in directoryRoot.EnumerateDirectories())
            {
                var match = MacChapterDirectory.Match(directory.Name);
                var path = Path.Combine(directory.FullName, match.Success ? "game.ios" : "data.win");
                if (File.Exists(path)) Add(match.Success ? match : ChapterDirectory.Match(directory.Name), path);
            }
            foreach (var file in directoryRoot.EnumerateFiles()) Add(ChapterFile.Match(file.Name), file.FullName);
        }

        void Add(Match match, string path)
        {
            if (!match.Success || !TryNumber(match.Groups[1].Value, out var chapter)) return;
            if (!chapters.TryGetValue(chapter, out var copies)) chapters.Add(chapter, copies = []);
            copies.Add(path);
        }
    }

    internal static bool IsInSignedMacBundle(string path)
    {
        for (var directory = new FileInfo(path).Directory; directory is not null; directory = directory.Parent)
            if (directory.Name.EndsWith(".app", StringComparison.OrdinalIgnoreCase) &&
                File.Exists(Path.Combine(directory.FullName, "Contents", "_CodeSignature", "CodeResources")))
                return true;
        return false;
    }

    internal static int[] ParseSelection(string selection)
    {
        var chapters = new SortedSet<int>();
        foreach (var value in selection.Split(',', StringSplitOptions.TrimEntries))
        {
            if (!TryNumber(value, out var chapter))
                throw new ArgumentException("Specify chapter numbers separated by commas, e.g. --chapters 1,3.");
            chapters.Add(chapter);
        }
        return chapters.ToArray();
    }
}
