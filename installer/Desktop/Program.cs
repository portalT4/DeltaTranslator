using System.Diagnostics;
using System.Globalization;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Layout;
using Avalonia.Media;
using Avalonia.Platform.Storage;
using Avalonia.Themes.Fluent;
using Avalonia.Threading;

namespace DeltaTranslator.Setup;

internal static class Program
{
    [STAThread]
    public static int Main(string[] args) => AppBuilder.Configure<SetupApplication>()
        .UsePlatformDetect()
        .StartWithClassicDesktopLifetime(args);
}

internal sealed class SetupApplication : Application
{
    public SetupApplication() { }

    public override void Initialize() => Styles.Add(new FluentTheme());

    public override void OnFrameworkInitializationCompleted()
    {
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            var window = new SetupWindow();
            desktop.MainWindow = window;
            if (desktop.Args is ["--smoke-test"])
                window.Opened += async (_, _) =>
                {
                    // Exercise the packaged UI and sidecar on a hosted runner without touching a game.
                    try
                    {
                        var result = await SetupWindow.RunPatcherAsync(["--help"]);
                        desktop.Shutdown(result.ExitCode == 0 && result.StandardOutput.Contains("DeltaTranslator Patcher", StringComparison.Ordinal) ? 0 : 1);
                    }
                    catch (Exception error)
                    {
                        Console.Error.WriteLine(error.Message);
                        desktop.Shutdown(1);
                    }
                };
        }
        base.OnFrameworkInitializationCompleted();
    }
}

internal sealed class SetupWindow : Window
{
    private readonly TextBox _folder = new() { Watermark = "/path/to/DELTARUNE" };
    private readonly Button _browse = new() { Content = "Browse…" };
    private readonly Button _detect = new() { Content = "Find chapters" };
    private readonly Button _install = new() { Content = "Install selected chapters", IsEnabled = false };
    private readonly StackPanel _chapters = new() { Spacing = 5 };
    private readonly CheckBox _signed = new() { VerticalContentAlignment = VerticalAlignment.Center };
    private readonly ProgressBar _progress = new() { IsIndeterminate = true, IsVisible = false };
    private readonly TextBlock _status = new() { TextWrapping = TextWrapping.Wrap };
    private readonly TextBox _log = new() { IsReadOnly = true, AcceptsReturn = true, TextWrapping = TextWrapping.Wrap, MinHeight = 70, MaxHeight = 150 };
    private readonly List<(int Chapter, CheckBox Box)> _choices = [];
    private string? _detectedFolder;
    private bool _busy;

    public SetupWindow()
    {
        Title = "DeltaTranslator";
        Width = 650;
        Height = 630;
        MinWidth = 470;
        MinHeight = 405;
        WindowStartupLocation = WindowStartupLocation.CenterScreen;
        Closing += (_, e) => { if (_busy) e.Cancel = true; };

        _folder.Text = DefaultSteamFolder();
        _signed.IsVisible = OperatingSystem.IsMacOS();
        _signed.Content = new TextBlock
        {
            Text = "Allow changes inside a signed DELTARUNE.app. This invalidates the game's signature and may prevent it from opening.",
            TextWrapping = TextWrapping.Wrap,
        };
        var folderRow = new Grid { ColumnDefinitions = new ColumnDefinitions("*,Auto,Auto"), ColumnSpacing = 8 };
        folderRow.Children.Add(_folder);
        Grid.SetColumn(_browse, 1); folderRow.Children.Add(_browse);
        Grid.SetColumn(_detect, 2); folderRow.Children.Add(_detect);

        Content = new ScrollViewer
        {
            HorizontalScrollBarVisibility = Avalonia.Controls.Primitives.ScrollBarVisibility.Disabled,
            Content = new StackPanel
            {
                Margin = new Thickness(24), Spacing = 10,
                Children =
                {
                    new TextBlock { Text = "DeltaTranslator", FontSize = 28, FontWeight = FontWeight.SemiBold },
                    new TextBlock { Text = "Close DELTARUNE, then choose its installation folder. In Steam, use Properties → Installed Files → Browse.", TextWrapping = TextWrapping.Wrap },
                    folderRow,
                    new TextBlock { Text = "Chapters to install", FontWeight = FontWeight.SemiBold },
                    new ScrollViewer { MaxHeight = 160, Content = _chapters },
                    _signed,
                    _install,
                    _progress,
                    _status,
                    _log,
                },
            },
        };
        _status.Text = "Select a game folder to begin. Nothing is installed until you choose chapters and click Install.";
        _log.IsVisible = false;
        _browse.Click += async (_, _) => await BrowseAsync();
        _detect.Click += async (_, _) => await DetectAsync();
        _install.Click += async (_, _) => await InstallAsync();
        _folder.TextChanged += (_, _) =>
        {
            if (_detectedFolder is not null && !string.Equals(_detectedFolder, _folder.Text, StringComparison.Ordinal))
                ClearDetection();
        };
    }

    private async Task BrowseAsync()
    {
        if (_busy) return;
        try
        {
            var folders = await StorageProvider.OpenFolderPickerAsync(new FolderPickerOpenOptions
            {
                Title = "Choose the DELTARUNE installation folder", AllowMultiple = false,
            });
            if (folders.FirstOrDefault()?.TryGetLocalPath() is { } folder)
            {
                _folder.Text = folder;
                await DetectAsync();
            }
        }
        catch (Exception error) { _status.Text = error.Message; }
    }

    private async Task DetectAsync()
    {
        if (_busy) return;
        ClearDetection();
        var path = _folder.Text;
        if (string.IsNullOrWhiteSpace(path) || !Path.IsPathFullyQualified(path) || !Directory.Exists(path))
        {
            _status.Text = "Choose an existing game installation folder.";
            return;
        }
        SetBusy(true);
        _status.Text = "Finding chapters…";
        _log.IsVisible = false;
        try
        {
            var result = await RunPatcherAsync(["list", path]);
            if (result.ExitCode != 0) throw new IOException(result.StandardError.Trim());
            foreach (var line in result.StandardOutput.Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (!int.TryParse(line, NumberStyles.None, CultureInfo.InvariantCulture, out var chapter) || chapter < 1)
                    throw new InvalidDataException("The patcher returned an invalid chapter list.");
                var box = new CheckBox { Content = $"Chapter {chapter}" };
                box.IsCheckedChanged += (_, _) => UpdateInstallButton();
                _choices.Add((chapter, box));
                _chapters.Children.Add(box);
            }
            _detectedFolder = path;
            _status.Text = _choices.Count == 0 ? "No supported chapter archives were found in this folder." : "Tick the chapters you want to install.";
        }
        catch (Exception error) { ClearDetection(); _status.Text = error.Message; }
        finally { SetBusy(false); }
    }

    private async Task InstallAsync()
    {
        if (_busy || _detectedFolder is not { } path) return;
        var selected = _choices.Where(x => x.Box.IsChecked == true).Select(x => x.Chapter.ToString(CultureInfo.InvariantCulture)).ToArray();
        if (selected.Length == 0) return;
        List<string> args = ["install", path, "--chapters", string.Join(',', selected)];
        if (OperatingSystem.IsMacOS() && _signed.IsChecked == true) args.Add("--allow-macos-bundle");
        SetBusy(true);
        _log.Clear();
        _log.IsVisible = true;
        _status.Text = "Installing… Keep the game closed until this finishes.";
        try
        {
            var result = await RunPatcherAsync(args, line => Dispatcher.UIThread.Post(() =>
            {
                _log.Text += line + Environment.NewLine;
                _log.CaretIndex = _log.Text?.Length ?? 0;
            }));
            _status.Text = result.ExitCode == 0
                ? "Done. The selected chapters are ready. Any replaced archives were backed up."
                : "Installation failed. See the details below.";
        }
        catch (Exception error) { _status.Text = error.Message; }
        finally { SetBusy(false); }
    }

    private void ClearDetection()
    {
        _detectedFolder = null;
        _signed.IsChecked = false;
        _choices.Clear();
        _chapters.Children.Clear();
        UpdateInstallButton();
    }

    private void UpdateInstallButton() => _install.IsEnabled = !_busy && _detectedFolder is not null && _choices.Any(x => x.Box.IsChecked == true);

    private void SetBusy(bool busy)
    {
        _busy = busy;
        _folder.IsEnabled = _browse.IsEnabled = _detect.IsEnabled = _chapters.IsEnabled = _signed.IsEnabled = !busy;
        _progress.IsVisible = busy;
        UpdateInstallButton();
    }

    private static string? DefaultSteamFolder()
    {
        var home = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
        var roots = OperatingSystem.IsMacOS()
            ? new[] { Path.Combine(home, "Library", "Application Support", "Steam") }
            : new[] { Path.Combine(home, ".local", "share", "Steam"), Path.Combine(home, ".steam", "steam"),
                Path.Combine(home, ".var", "app", "com.valvesoftware.Steam", ".local", "share", "Steam") };
        return roots.Select(root => Path.Combine(root, "steamapps", "common", "DELTARUNE")).FirstOrDefault(Directory.Exists);
    }

    internal static async Task<(int ExitCode, string StandardOutput, string StandardError)> RunPatcherAsync(
        IEnumerable<string> args, Action<string>? output = null)
    {
        var payload = OperatingSystem.IsMacOS()
            ? Path.Combine(AppContext.BaseDirectory, "..", "Resources", "patcher")
            : Path.Combine(AppContext.BaseDirectory, "patcher");
        var executable = Path.GetFullPath(Path.Combine(payload, "DeltaTranslator.Patcher"));
        var info = new ProcessStartInfo(executable)
        {
            UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true,
            WorkingDirectory = Path.GetDirectoryName(executable)!,
        };
        foreach (var arg in args) info.ArgumentList.Add(arg);
        using var process = Process.Start(info) ?? throw new IOException("Could not start the patcher.");
        async Task<string> ReadAsync(StreamReader reader)
        {
            var text = new System.Text.StringBuilder();
            while (await reader.ReadLineAsync().ConfigureAwait(false) is { } line)
            {
                text.AppendLine(line);
                output?.Invoke(line);
            }
            return text.ToString();
        }
        var stdout = ReadAsync(process.StandardOutput);
        var stderr = ReadAsync(process.StandardError);
        await process.WaitForExitAsync();
        return (process.ExitCode, await stdout, await stderr);
    }
}
