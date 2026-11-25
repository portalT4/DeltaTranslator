# Requires .NET SDK 10 and Inno Setup 6.3 or newer.
param([string]$InnoCompiler = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe")
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath $InnoCompiler)) {
    throw "Inno Setup compiler not found: $InnoCompiler. Set -InnoCompiler to the path to ISCC.exe."
}
$publish = Join-Path $root 'artifacts/patcher'
if (Test-Path -LiteralPath $publish) { Remove-Item -Recurse -Force -LiteralPath $publish }

dotnet publish (Join-Path $root 'Patcher/DeltaTranslator.Patcher.csproj') -c Release -r win-x64 `
    --self-contained true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -o $publish
if ($LASTEXITCODE -ne 0) { throw "dotnet publish failed ($LASTEXITCODE)." }
Copy-Item (Join-Path $root 'Patcher/LICENSE') (Join-Path $publish 'LICENSE.txt')
Copy-Item (Join-Path $root 'vendor/UndertaleModTool/Underanalyzer/LICENSE') (Join-Path $publish 'Underanalyzer-LICENSE.txt')
& $InnoCompiler (Join-Path $PSScriptRoot 'DeltaTranslator.iss')
if ($LASTEXITCODE -ne 0) { throw "Inno Setup compilation failed ($LASTEXITCODE)." }
