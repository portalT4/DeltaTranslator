"""Build the default and DubstepDude overlay fonts. See README.md."""
import argparse
from hashlib import sha256
from pathlib import Path

from fontTools.ttLib import TTFont
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent
SOURCES = (
    (13, 'd189936765d93972ee4e7241292359bd528834a3da7b7ffc741d532251c94201'),
    (12, '262e31822e0a75be567b02320bfa092143d871e8a273e529d1c5ab0c04cd215f'),
)
DUBSTEPDUDE = (16, '9138f98c515942bf3742c993c2b19f4538c0212650c1d242e2d07ec8f1284ca7')
REQUIRED = ('ÄÖÜäöüßẞÁÉÍÓÚÑáéíóúñ¿¡ÀÂÃÇÊÔÕàâãçêôõ'
            'ĄĆĘŁŃÓŚŹŻąćęłńóśźżҐЄІЇґєії₴ÇĞİÖŞÜçğıöşü₺'
            'ÀÂÆÇÉÈÊËÎÏÔŒÙÛÜŸàâæçéèêëîïôœùûüÿÌÒìò«»'
            'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя')


def load(path, size, digest):
    if sha256(path.read_bytes()).hexdigest() != digest:
        raise ValueError(f'Unexpected font version: {path}')
    with TTFont(path) as source:
        return ImageFont.truetype(path, size), set(source.getBestCmap())


def build(determination, monocraft):
    fonts = [load(path, *source) for path, source in zip((determination, monocraft), SOURCES)]
    russian = load(ROOT.parent / 'determination-mono.ttf', *DUBSTEPDUDE)
    render(fonts, 'overlay', 'glyphs')
    render([russian, *fonts], 'overlay-ru', 'glyphs-ru', native_face=russian[0])


def render(fonts, atlas_name, metrics_name, native_face=None):
    available = set.union(*(cmap for _, cmap in fonts))
    required = {*range(0x20, 0x7F), *map(ord, REQUIRED)}
    # The main face must supply the Russian alphabet, not fall back to Monocraft.
    russian = {ord(c) for c in REQUIRED if 'А' <= c <= 'я' or c in 'Ёё'}
    if missing := russian - fonts[0][1]:
        raise ValueError(f'Primary face is missing Russian glyphs: {sorted(missing)}')
    if missing := required - available:
        raise ValueError(f'Missing required glyphs: {sorted(missing)}')
    narrow_space = 0x202F
    desired = required | {*range(0xA0, 0x180), *range(0x400, 0x460), *map(ord, '–—‘’‚“”„…€')}
    numero = ord('№')
    apostrophe = ord('ʼ')
    codepoints = sorted((desired & available) | {narrow_space, numero, apostrophe})

    size, ascent, height, advance = 16, 15, 19, 8
    columns, cell_w, cell_h = 32, 16, 21  # transparent margin around each glyph
    atlas = Image.new('RGBA', (512, ((len(codepoints) + columns - 1) // columns) * cell_h), (255, 255, 255, 0))
    rows = [f'{size};{ascent};{height}']
    for i, codepoint in enumerate(codepoints):
        width = shift = advance
        mask = Image.new('L', (width, height))
        if codepoint == narrow_space:
            shift = 4
        elif codepoint == numero and (native_face is None or codepoint not in fonts[0][1]):
            # Keep the Russian numero sign in the same eight-pixel cell.
            for y, row in enumerate(('#..#.##.', '##.#.#.#', '#.#..#.#', '#..#.##.',
                                     '#..#....', '#..#.###', '#..#....', '#..#....'), ascent - 8):
                for x, pixel in enumerate(row):
                    if pixel == '#':
                        mask.putpixel((x, y), 255)
        else:
            # Ukrainian uses both U+02BC and U+2019 as apostrophes; share the same pixel shape.
            source_char = ord('’') if codepoint == apostrophe else codepoint
            font, _ = next(source for source in fonts if source_char in source[1])
            char = chr(source_char)
            if font is native_face:
                # Keep the Russian adaptation's wide glyphs instead of squeezing them into 8px.
                width = shift = round(font.getlength(char))
                if not 0 < width <= cell_w - 2:
                    raise ValueError(f'Glyph advance out of bounds: U+{codepoint:04X}')
                mask = Image.new('L', (width, height))
            left, top, right, bottom = font.getbbox(char, anchor='ls')
            # Draw with room for overhangs, then center only if ink crosses the fixed cell.
            if not (-ascent <= top <= bottom <= height - ascent and right - left <= cell_w - 2):
                raise ValueError(f'Glyph out of bounds: U+{codepoint:04X}')
            scratch = Image.new('L', (cell_w, height))
            draw = ImageDraw.Draw(scratch)
            draw.fontmode = '1'  # bilevel mask
            draw.text((1 - left, ascent), char, font=font, anchor='ls', fill=255)
            if ink := scratch.getbbox():
                dest_x = ink[0] + left - 1
                if dest_x < 0 or dest_x + ink[2] - ink[0] > width:
                    dest_x = max(0, (width - (ink[2] - ink[0])) // 2)
                glyph = scratch.crop(ink)
                if glyph.width > width:
                    glyph = glyph.resize((width, glyph.height), Image.Resampling.NEAREST)
                mask.paste(glyph, (dest_x, ink[1]))
        x, y = 1 + i % columns * cell_w, 1 + i // columns * cell_h
        glyph = Image.new('RGBA', mask.size, (255, 255, 255))
        glyph.putalpha(mask)
        atlas.paste(glyph, (x, y))
        rows.append(f'{codepoint};{x};{y};{width};{height};{shift};0')

    atlas.save(ROOT / f'{atlas_name}.png', optimize=True)
    (ROOT / f'{metrics_name}.csv').write_text('\n'.join(rows) + '\n', encoding='ascii', newline='\n')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('determination', type=Path)
    parser.add_argument('monocraft', type=Path)
    args = parser.parse_args()
    build(args.determination, args.monocraft)
