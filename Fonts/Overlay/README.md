# DeltaTranslator overlay fonts

- **Russian:** Determination Mono adaptation by **DubstepDude**, contributed as [`determination-mono.ttf`](../determination-mono.ttf) in `2e5e8c6`. The source metadata names the face “8bitoperator JVE (RUS)”, credits nipcen (2011) and specifies [CC BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/). The bitmap glyphs derived from this source retain those terms. The Russian atlas keeps the wider glyphs in this adaptation.
- **Other languages and the language picker:** [Determination with Cyrillic glyphs](https://github.com/StackTheFennec/Determination/tree/f064e5afc1163b8d17c6bdedf6cebe280df892c1), credited to theFIZZYnator, with Cyrillic by Dartjuk and fixes by Yurijmi.
- **Fallback glyphs:** **Monocraft** by **Idrees Hassan**, [SIL OFL 1.1](OFL.txt), fills gaps in both atlases. These include Ukrainian `Ґ/ґ` and `₴`, Turkish `₺` and some letters with diacritics. The Ukrainian apostrophe `ʼ` shares the glyph for `’`.

The original game fonts are unchanged. See [the full font notice](Determination-Source.txt), which ships with the installer alongside the Monocraft license.

## Regenerate the atlases

The Russian source is already in this repository. Download these other pinned sources:

| Source | SHA-256 |
| --- | --- |
| [Determination-Regular.otf](https://github.com/StackTheFennec/Determination/blob/f064e5afc1163b8d17c6bdedf6cebe280df892c1/Determination-Regular.otf) | `d189936765d93972ee4e7241292359bd528834a3da7b7ffc741d532251c94201` |
| [Monocraft.ttf](https://github.com/IdreesInc/Monocraft/blob/e498bf70aeb25b4bdcff1e44d878fb2cb4f7c2a9/dist/Monocraft-ttf/Monocraft.ttf) | `262e31822e0a75be567b02320bfa092143d871e8a273e529d1c5ab0c04cd215f` |

```sh
python -m pip install Pillow==13.0.0 fonttools==4.68.0
python Fonts/Overlay/generate.py path/to/Determination-Regular.otf path/to/Monocraft.ttf
```

The generator verifies both atlases cover all nine translation languages and renders binary-alpha pixel glyphs. Each CSV row stores codepoint, rectangle, advance and offset; the header stores size, ascent and line height. The installer embeds only the generated bitmap atlases and their metrics, not the source font files.
