using System.Security.Cryptography;
using System.Text;
using DeltaTranslator;
using UndertaleModLib;

Console.OutputEncoding = Encoding.UTF8;
var log = Console.Out;
StreamWriter? logFile = null;
try
{
    if (args.Length == 0 || args is ["--help" or "-h"])
    {
        log.WriteLine("DeltaTranslator Patcher\n  patch <input-archive> <output-archive>\n  list <game-folder> [--log <file>]\n  install <game-folder> [--chapters <1,3,...>] [--log <file>] [--allow-macos-bundle]\n  verify <patched-archive>");
        return 0;
    }
    switch (args)
    {
        case ["patch", var input, var output]:
            PatchFile(Path.GetFullPath(input), Path.GetFullPath(output));
            break;
        case ["list" or "install", var gameFolder, ..]:
            var listing = args[0] == "list";
            string? logPath = null;
            int[]? selected = null;
            var allowMacBundle = false;
            for (var i = 2; i < args.Length; i++)
            {
                var option = args[i];
                if (option == "--allow-macos-bundle" && !listing && !allowMacBundle)
                {
                    allowMacBundle = true;
                    continue;
                }
                if (i + 1 >= args.Length) throw new ArgumentException($"Missing value for {args[i]}.");
                switch (option)
                {
                    case "--log" when logPath is null:
                        logPath = args[++i];
                        break;
                    case "--chapters" when !listing && selected is null:
                        selected = ChapterFiles.ParseSelection(args[++i]);
                        break;
                    default:
                        throw new ArgumentException($"Invalid or repeated option: {args[i]}.");
                }
            }
            if (logPath is not null)
            {
                logFile = new StreamWriter(new FileStream(logPath, FileMode.CreateNew, FileAccess.Write, FileShare.Read)) { AutoFlush = true };
                log = logFile;
            }
            var chapters = ChapterFiles.Discover(Path.GetFullPath(gameFolder));
            if (listing)
            {
                foreach (var chapter in chapters.Keys) log.WriteLine(chapter);
            }
            else Install(chapters, selected, allowMacBundle);
            break;
        case ["verify", var file]:
            VerifyFile(file);
            log.WriteLine($"Verified: {file}");
            break;
        default:
            Console.Error.WriteLine("Invalid arguments. Run with --help.");
            return 2;
    }
    return 0;
}
catch (Exception ex)
{
    Console.Error.WriteLine($"Error: {ex.Message}");
    if (logFile is not null) logFile.WriteLine($"Error: {ex.Message}");
    return 1;
}
finally { logFile?.Dispose(); }

void PatchFile(string input, string output)
{
    if (File.Exists(output)) throw new IOException($"Output file already exists: {output}.");
    var staged = TempNextTo(output);
    try
    {
        Stage(input, staged, chapter: null, copyIfPatched: true);
        File.Move(staged, output); // Never overwrite an input or a pre-existing output.
        log.WriteLine($"Wrote: {output}");
    }
    finally { DeleteTemp(staged); }
}

void Install(SortedDictionary<int, List<string>> chapters, int[]? selected, bool allowMacBundle)
{
    var inputs = new List<(string Path, int Chapter)>();
    foreach (var chapter in selected ?? chapters.Keys.ToArray())
    {
        if (!chapters.TryGetValue(chapter, out var matches))
            throw new FileNotFoundException($"Chapter {chapter} was not found in the selected folder.");
        if (matches.Count > 1)
            throw new IOException($"Multiple data files found for chapter {chapter}. Use patch mode with an explicit input.");
        if (!allowMacBundle && ChapterFiles.IsInSignedMacBundle(matches[0]))
            throw new IOException("Installing inside the signed DELTARUNE.app invalidates its signature and may stop the game from launching. " +
                "Use patch mode to write a separate file, or repeat install with --allow-macos-bundle if you accept the risk.");
        inputs.Add((matches[0], chapter));
    }
    if (inputs.Count == 0)
        throw new FileNotFoundException("No DELTARUNE chapter data files were found in the selected folder.");

    var staged = new List<(string Input, string Temp, string Hash)>();
    var prepared = new List<(string Input, string Temp, string Backup, string Hash)>();
    var backups = new List<string>();
    var replaced = new List<(string Input, string Backup)>();
    try
    {
        foreach (var input in inputs)
        {
            var temp = TempNextTo(input.Path);
            try
            {
                var hash = Stage(input.Path, temp, input.Chapter, copyIfPatched: false);
                if (hash is null) continue;
                staged.Add((input.Path, temp, hash));
            }
            catch { DeleteTemp(temp); throw; }
        }
        // Validate all results, and back up all inputs, before replacing any of them.
        foreach (var item in staged)
        {
            var backup = item.Input + ".deltatranslator.bak";
            var reuse = File.Exists(backup);
            if (reuse && HashFile(backup) != item.Hash)
            {
                backup = $"{item.Input}.deltatranslator.{item.Hash}.bak";
                reuse = File.Exists(backup);
                if (reuse && HashFile(backup) != item.Hash)
                    throw new IOException($"Backup does not match the current archive: {backup}.");
            }
            if (reuse) log.WriteLine($"Reusing backup: {backup}");
            else
            {
                log.WriteLine($"Backing up: {item.Input}");
                var tempBackup = TempNextTo(item.Input);
                try
                {
                    CopyVerifiedBackup(item.Input, tempBackup, item.Hash);
                    File.Move(tempBackup, backup); // Never overwrite a previous backup.
                    backups.Add(backup);
                }
                finally { DeleteTemp(tempBackup); }
            }
            prepared.Add((item.Input, item.Temp, backup, item.Hash));
        }
        foreach (var item in prepared)
        {
            log.WriteLine($"Installing: {item.Input}");
            if (HashFile(item.Input) != item.Hash)
                throw new IOException($"Input changed while it was being patched: {item.Input}.");
            File.Move(item.Temp, item.Input, overwrite: true);
            replaced.Add((item.Input, item.Backup));
        }
    }
    catch (Exception installationError)
    {
        var keep = new HashSet<string>();
        foreach (var item in Enumerable.Reverse(replaced))
        {
            var temp = TempNextTo(item.Input);
            try
            {
                File.Copy(item.Backup, temp);
                File.Move(temp, item.Input, overwrite: true);
            }
            catch (IOException) { keep.Add(item.Backup); }
            catch (UnauthorizedAccessException) { keep.Add(item.Backup); }
            finally { DeleteTemp(temp); }
        }
        foreach (var backup in backups.Where(b => !keep.Contains(b))) DeleteTemp(backup);
        if (keep.Count > 0)
            throw new IOException($"{installationError.Message} Rollback incomplete; restore from: {string.Join(", ", keep)}.", installationError);
        throw;
    }
    finally
    {
        foreach (var item in staged) DeleteTemp(item.Temp);
    }
    foreach (var item in replaced) log.WriteLine($"Installed: {item.Input}\nBackup: {item.Backup}");
    if (staged.Count == 0) log.WriteLine("Already installed. No files changed.");
}

string? Stage(string input, string destination, int? chapter, bool copyIfPatched)
{
    log.WriteLine($"Reading: {input}");
    using var stream = File.OpenRead(input);
    var hash = Convert.ToHexString(SHA256.HashData(stream));
    stream.Position = 0;
    var data = UndertaleIO.Read(stream, OnWarning);
    log.WriteLine($"Preparing patch: {input}");
    if (!GamePatch.Apply(data, hash, chapter))
    {
        log.WriteLine("Already patched.");
        if (copyIfPatched) File.Copy(input, destination);
        return null;
    }
    log.WriteLine($"Writing patched archive: {input}");
    using (var output = new FileStream(destination, FileMode.CreateNew, FileAccess.ReadWrite))
    {
        UndertaleIO.Write(output, data);
        output.Flush(flushToDisk: true);
    }
    log.WriteLine($"Verifying patched archive: {input}");
    VerifyFile(destination);
    return hash;
}

void VerifyFile(string file)
{
    using var stream = File.OpenRead(file);
    GamePatch.Verify(UndertaleIO.Read(stream, OnWarning));
}

void OnWarning(string message, bool important)
{
    if (important) throw new InvalidDataException(message);
    log.WriteLine($"Warning: {message}");
}

static void CopyVerifiedBackup(string input, string output, string expectedHash)
{
    using var source = File.OpenRead(input);
    using var target = new FileStream(output, FileMode.CreateNew, FileAccess.Write);
    using var sha256 = IncrementalHash.CreateHash(HashAlgorithmName.SHA256);
    var buffer = new byte[128 * 1024];
    int count;
    while ((count = source.Read(buffer)) > 0)
    {
        target.Write(buffer, 0, count);
        sha256.AppendData(buffer, 0, count);
    }
    if (Convert.ToHexString(sha256.GetHashAndReset()) != expectedHash)
        throw new IOException($"Input changed while it was being patched: {input}.");
    target.Flush(flushToDisk: true);
}

static string HashFile(string path)
{
    using var stream = File.OpenRead(path);
    return Convert.ToHexString(SHA256.HashData(stream));
}

static string TempNextTo(string path) => Path.Combine(Path.GetDirectoryName(path)!, $".deltatranslator-{Guid.NewGuid():N}.tmp");

static void DeleteTemp(string path)
{
    try { File.Delete(path); }
    catch (IOException) { }
    catch (UnauthorizedAccessException) { }
}
