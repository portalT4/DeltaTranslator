![DeltaTranslator cover](Cover.png)

[![Telegram](https://img.shields.io/badge/Telegram-X3aBapkaTriangle-229ED9?logo=telegram&logoColor=white)](https://t.me/X3aBapkaTriangle)

**English** · [Русский](docs/README.ru.md) · [Español](docs/README.es.md) · [Português (Brasil)](docs/README.pt-BR.md) · [Deutsch](docs/README.de.md) · [Polski](docs/README.pl.md) · [Українська](docs/README.uk.md) · [Türkçe](docs/README.tr.md) · [Italiano](docs/README.it.md) · [Français](docs/README.fr.md)

# DeltaTranslator

DeltaTranslator is an unofficial DELTARUNE mod that shows machine translations over the original game text. Translation targets: **Russian, Spanish, Brazilian Portuguese (`pt`), German, Polish, Ukrainian, Turkish, Italian, and French**. The Windows installer interface is available in **English, Russian, Spanish, Brazilian Portuguese, and German**. English is not an in-game translation target.

## What it translates

- Supported dialogue in the overworld and in battles, and menu text written by supported dialogue objects (`obj_writer`, `obj_menuwriter`). It does not translate every menu or battle label.
- Answer options in supported choice panels.
- Speech bubbles implemented with `obj_talkbubble`, including those used in Chapter 5. The translation follows its own bubble and is drawn above it, independently of ordinary dialogue. Chapters without that object skip bubble translation.
- Mini-dialogue asides and Tenna’s speech bubbles are translated next to the original. Known animated inserts such as **Lovely** are translated only as part of the dialogue, without a separate caption.

Other text baked into images, text drawn directly by other game scripts, and unhandled elements such as rhythm-game lyrics are not translated. The original text and game fonts are not replaced.

## How it works

On request, the mod reads active supported text and removes game formatting codes where applicable. It sends the resulting text and the selected target language to **Google Translate** over HTTPS; the source language is detected automatically. Results are machine-generated, rendered in a separate overlay and fetched asynchronously. Auto mode checks for changes and avoids resending unchanged text for the same active slot. **Internet access is required.** With auto mode off, it only sends translation requests when you press F5. The mod is not affiliated with Google, DELTARUNE or any fan translation team.

| Key | Action |
| --- | --- |
| **F1** | Open or close the language picker; use the arrow keys and **Enter**, or press **1–9** to select directly |
| **F2** | Toggle automatic positioning where supported |
| **F3** | Toggle automatic translation (off at startup) |
| **F5** | Translate the current supported text |
| **F6** | Clear the translation overlay |

The in-game device menu displays these shortcuts and the current auto settings. The Russian overlay uses **DubstepDude’s Determination Mono adaptation**; other languages use Determination with fallback glyphs. See [font sources and credits](Fonts/Overlay/README.md).

## Download and install

Open [Releases](https://github.com/portalT4/DeltaTranslator/releases) and download the installer for your system from **Assets**. Close DELTARUNE first.

**Linux / Steam Deck and macOS:** I don’t have a Mac or a Linux machine. You may run into issues with these builds.

| Platform | Installer |
| --- | --- |
| Windows x64 | `DeltaTranslator-Setup-win-x64.exe` |
| Linux x64 / Steam Deck (game via Proton) | `DeltaTranslator-Setup-linux-x64.AppImage` |
| macOS, Apple Silicon | `DeltaTranslator-Setup-osx-arm64.zip` → `DeltaTranslator.app` |
| macOS, Intel | `DeltaTranslator-Setup-osx-x64.zip` → `DeltaTranslator.app` |

- **Windows:** open the `.exe`. The wizard does not request administrator rights by default; use `/ALLUSERS` only for a protected folder. For silent installation, use `/CHAPTERS=1,2` to limit the selection; omitting it selects all detected chapters.
- **Linux / Steam Deck:** open the `.AppImage` from your file manager (Desktop Mode on Steam Deck). If needed, mark it executable in the file's **Properties**. Your system must support running AppImages.
- **macOS:** extract the ZIP and open `DeltaTranslator.app` in Finder. The app is not notarized, so Gatekeeper may block it. Editing resources in a signed copy of **the game** invalidates its signature and may prevent it from opening. The installer requires explicit consent for this and does not re-sign the game or change Gatekeeper. Running the modified native Mac game has not been verified.

In the installer, choose the game folder (**Steam → Properties → Installed Files → Browse**), not the saves folder or the root `data.win`. Tick the detected chapters you want, then click **Install**. Nothing is selected by default. No separate .NET installation or terminal commands are needed.

## Compatibility, updates and removal

The patcher compiles and adds the mod to the selected chapter archives without downloading game files or editing saves. It checks the result before replacing an archive, and keeps a matching `.deltatranslator.bak` or `.deltatranslator.<SHA-256>.bak` alongside it. GitHub Actions builds the installers without game archives. Archive tests for Chapters 1 and 2 require a local copy of the game; actual play on every platform and build is not guaranteed. Older standalone demos with one shared archive, mobile ports, and consoles are not supported.

To update or remove the mod, close the game and restore the original matching archive or verify the game files in Steam. Do not restore a backup from a different game version. On macOS, move added `.bak` files out of the signed `.app` when restoring it. To update DeltaTranslator, reinstall it over the restored clean archives.

[Screenshots](Screenshots/) · [Build and development notes](docs/DEVELOPMENT.md) · [Font source and license](Fonts/Overlay/README.md)
