#!/usr/bin/env bash
# Build a self-contained graphical installer on Linux or macOS.
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 {linux-x64|osx-arm64|osx-x64}" >&2
    exit 2
fi
rid=$1
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
out="$root/artifacts/installer"
name="DeltaTranslator-Setup-$rid"
mkdir -p -- "$out"
staging=$(mktemp -d "$out/.desktop.XXXXXXXX")
trap 'rm -rf -- "$staging"' EXIT

case "$rid" in
    linux-x64)
        : "${APPIMAGETOOL:?Set APPIMAGETOOL to the path to the x86_64 appimagetool executable.}"
        [[ $(uname -s) == Linux ]]
        app="$staging/DeltaTranslator.AppDir"
        bin="$app/usr/bin"
        patcher="$bin/patcher"
        ;;
    osx-arm64|osx-x64)
        [[ $(uname -s) == Darwin ]]
        app="$staging/DeltaTranslator.app"
        bin="$app/Contents/MacOS"
        patcher="$app/Contents/Resources/patcher"
        ;;
    *) echo "Unsupported target: $rid" >&2; exit 2 ;;
esac

publish() {
    dotnet publish "$1" -c Release -r "$rid" --self-contained true \
        -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -o "$2"
}
if [[ "$rid" == linux-x64 ]]; then
    publish "$root/installer/Desktop/DeltaTranslator.Setup.csproj" "$bin"
    license_dir="$bin"
else
    # Contents/MacOS must contain executable code, not PDBs or license files.
    publish "$root/installer/Desktop/DeltaTranslator.Setup.csproj" "$staging/gui"
    mkdir -p "$bin" "$app/Contents/Resources"
    mv "$staging/gui/DeltaTranslator.Setup" "$bin/DeltaTranslator.Setup"
    license_dir="$app/Contents/Resources"
fi
publish "$root/Patcher/DeltaTranslator.Patcher.csproj" "$patcher"
cp -- "$root/installer/Desktop/Avalonia-LICENSE.txt" "$license_dir/Avalonia-LICENSE.txt"
cp -- "$root/Patcher/LICENSE" "$patcher/LICENSE.txt"
cp -- "$root/vendor/UndertaleModTool/Underanalyzer/LICENSE" "$patcher/Underanalyzer-LICENSE.txt"

if [[ "$rid" == linux-x64 ]]; then
    cat > "$app/AppRun" <<'SCRIPT'
#!/bin/sh
here=$(dirname -- "$(readlink -f -- "$0")")
exec "$here/usr/bin/DeltaTranslator.Setup" "$@"
SCRIPT
    chmod +x "$app/AppRun"
    cat > "$app/deltatranslator.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=DeltaTranslator
Exec=DeltaTranslator.Setup
Icon=deltatranslator
Categories=Game;Utility;
Terminal=false
DESKTOP
    cat > "$app/deltatranslator.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128">
  <rect width="128" height="128" rx="24" fill="#1a1824"/>
  <path d="M64 23 107 99H21Zm0 27L45 85h38Z" fill="#a8a0ff" fill-rule="evenodd"/>
</svg>
SVG
    ARCH=x86_64 APPIMAGE_EXTRACT_AND_RUN=1 "$APPIMAGETOOL" --no-appstream "$app" "$staging/$name.AppImage"
    chmod +x "$staging/$name.AppImage"
    artifact="$name.AppImage"
else
    version=$(sed -n 's/^AppVersion=\([0-9.]*\).*$/\1/p' "$root/installer/DeltaTranslator.iss")
    [[ -n "$version" ]]
    cat > "$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>DeltaTranslator.Setup</string>
  <key>CFBundleIdentifier</key><string>com.deltatranslator.setup</string>
  <key>CFBundleName</key><string>DeltaTranslator</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>$version</string>
  <key>CFBundleVersion</key><string>$version</string>
  <key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
    # Ad-hoc signing is not Developer ID signing or notarization.
    codesign --force --sign - "$patcher/DeltaTranslator.Patcher"
    codesign --force --sign - "$app"
    codesign --verify --deep --strict "$app"
    artifact="$name.zip"
    ditto -c -k --keepParent "$app" "$staging/$artifact"
fi
mv -f -- "$staging/$artifact" "$out/$artifact"
printf 'Created: %s\n' "$out/$artifact"
