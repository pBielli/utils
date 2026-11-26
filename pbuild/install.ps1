# Installs the pbuild command for this Windows user: copies pbuild to %LOCALAPPDATA%\pbuild\bin and adds it to the user PATH.
# After this, any new cmd/PowerShell window can run:  pbuild pBielli/switchboard
$ErrorActionPreference = 'Stop'
$bin = Join-Path $env:LOCALAPPDATA 'pbuild\bin'
New-Item -ItemType Directory -Force -Path $bin | Out-Null
foreach ($f in 'pbuild.ps1', 'pbuild.cmd') {
    $src = Join-Path $PSScriptRoot $f
    if (Test-Path $src) { Copy-Item $src $bin -Force }
    else { Invoke-WebRequest "https://raw.githubusercontent.com/pBielli/utils/main/pbuild/$f" -OutFile (Join-Path $bin $f) -UseBasicParsing }
}
$path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($path -split ';') -notcontains $bin) { [Environment]::SetEnvironmentVariable('Path', ($path.TrimEnd(';') + ';' + $bin), 'User') }
Write-Host "pbuild installed in $bin. Open a NEW cmd window and run:  pbuild pBielli/switchboard" -ForegroundColor Green
