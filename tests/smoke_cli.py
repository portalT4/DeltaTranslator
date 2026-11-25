"""CLI and optional Windows installer smoke tests, using user-supplied clean archives."""
import argparse
import hashlib
from pathlib import Path
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument('--installer', type=Path)
parser.add_argument('--fixtures', type=Path, required=True, help='directory with clean data_ch1.win and data_ch2.win')
parser.add_argument('cli', nargs='+', help='patcher executable, or dotnet and the patcher DLL')
args = parser.parse_args()
fixtures = args.fixtures.resolve()


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def run(command, *parameters, code=0):
    invocation = [*command, *map(str, parameters)]
    process = subprocess.run(invocation, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=180)
    assert process.returncode == code, (invocation, process.returncode, process.stdout, process.stderr)
    return process.stdout + process.stderr


with tempfile.TemporaryDirectory(prefix='DeltaTranslator ') as folder:
    path = Path(folder)
    inputs = [fixtures / f'data_ch{chapter}.win' for chapter in (1, 2)]
    original = [sha(file) for file in inputs]
    patched = path / 'result.win'
    run(args.cli, 'patch', inputs[0], patched)
    run(args.cli, 'verify', patched)
    patched_hash = sha(patched)
    run(args.cli, 'patch', inputs[0], patched, code=1)
    assert sha(patched) == patched_hash
    assert 'Already patched' in run(args.cli, 'patch', patched, path / 'same.win')
    assert sha(path / 'same.win') == patched_hash

    game = path / 'Тест DELTARUNE'
    chapter1 = game / 'chapter1_windows' / 'data.win'
    chapter1.parent.mkdir(parents=True)
    chapter2 = game / 'chapter2_windows' / 'data.win'
    chapter2.parent.mkdir()
    shutil.copyfile(inputs[0], chapter1)
    chapter2.write_bytes(b'not game data')
    backup1 = chapter1.with_suffix('.win.deltatranslator.bak')
    backup2 = chapter2.with_suffix('.win.deltatranslator.bak')
    chapter3 = game / 'data_ch3.win'
    shutil.copyfile(inputs[0], chapter3)  # Recognized layout, but deliberately mismatched archive header.
    (game / 'chapter4_windows').mkdir()  # No data.win: not installed.
    assert run(args.cli, 'list', game).splitlines() == ['1', '2', '3']
    assert 'Expected chapter 3, but found chapter 1' in run(args.cli, 'install', game, '--chapters', '3', code=1)
    assert 'Chapter 4 was not found' in run(args.cli, 'install', game, '--chapters', '4', code=1)
    assert sha(chapter3) == original[0] and not chapter3.with_suffix('.win.deltatranslator.bak').exists()
    chapter3.unlink()
    assert 'Installed:' in run(args.cli, 'install', game, '--chapters', '1')
    run(args.cli, 'verify', chapter1)
    assert chapter2.read_bytes() == b'not game data' and not backup2.exists()
    assert sha(backup1) == original[0]
    shutil.copyfile(backup1, chapter1)
    backup1.unlink()

    run(args.cli, 'install', game, code=1)
    assert sha(chapter1) == original[0] and not backup1.exists() and not backup2.exists()
    assert chapter2.read_bytes() == b'not game data'

    shutil.copyfile(inputs[1], chapter2)
    shutil.copyfile(inputs[0], backup1)  # A matching backup from an earlier installation.
    backup2.write_text('do not overwrite this')  # An older, different backup must be kept too.
    backup2_current = chapter2.with_suffix(f'.win.deltatranslator.{original[1].upper()}.bak')
    log = path / 'patch log.txt'
    run(args.cli, 'install', game, '--log', log)
    log_text = log.read_text(encoding='utf-8')
    assert 'Installed:' in log_text and 'Reusing backup:' in log_text
    assert backup2.read_text() == 'do not overwrite this'
    installed = [sha(chapter1), sha(chapter2)]
    assert installed != original
    for file in (chapter1, chapter2):
        run(args.cli, 'verify', file)
    assert 'Already installed' in run(args.cli, 'install', game)
    assert [sha(chapter1), sha(chapter2)] == installed
    assert [sha(backup1), sha(backup2_current)] == original
    assert [sha(file) for file in inputs] == original
    assert not list(path.rglob('.deltatranslator-*.tmp'))

    if args.installer:
        shutil.copyfile(backup1, chapter1)
        shutil.copyfile(backup2_current, chapter2)
        backup1.unlink()
        setup = [str(args.installer.resolve())]
        setup_log = path / 'setup.log'
        setup_args = ('/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', f'/DIR={game}', f'/LOG={setup_log}')

        def install_with_setup(*options):
            try:
                run(setup, *setup_args, *options)
            except (AssertionError, subprocess.TimeoutExpired):
                if setup_log.exists():
                    print(setup_log.read_text(encoding='utf-8-sig', errors='replace')[-12000:])
                raise

        install_with_setup('/LANG=ru', '/CHAPTERS=2')
        run(args.cli, 'verify', chapter2)
        assert sha(chapter1) == original[0] and not backup1.exists()
        assert sha(backup2_current) == original[1] and backup2.read_text() == 'do not overwrite this'
        install_with_setup()  # Default silent installation patches all detected chapters.
        run(args.cli, 'verify', chapter1)
        assert [sha(backup1), sha(backup2_current)] == original
        print('Windows installer: selected chapters, silent defaults and backups passed.')
    print('CLI: chapter discovery, selection, verify, idempotence, protection of existing files, invalid input and backups passed.')
