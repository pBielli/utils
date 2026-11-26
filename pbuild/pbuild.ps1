<#
pbuild - builds any pBielli app on this Windows PC from a build file, without CI.

  pbuild pBielli/switchboard            clone/update the repo, read its build.json, build
  pbuild C:\path\to\build.json          build from that file (repo = the folder it sits in, unless "repo" is set)
  pbuild pBielli/switchboard -Tools     only check/install the tools the build file asks for
  pbuild pBielli/switchboard -NoUpdate  build what is on disk (no git fetch/reset)

Build file (build.json, in the repo root):
{
  "name": "Switchboard",
  "repo": "pBielli/switchboard",          // optional when building a local file
  "branch": "main",
  "tools": [
    { "name": "Git", "command": "git", "winget": "Git.Git" },
    { "name": ".NET 10 SDK", "check": "dotnet --list-sdks", "match": "^10\\.", "winget": "Microsoft.DotNet.SDK.10" },
    { "name": "VC++ build tools", "vswhere": "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
      "winget": "Microsoft.VisualStudio.2022.BuildTools", "override": "--passive --wait --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" },
    { "name": "Inno Setup 6", "paths": ["%ProgramFiles(x86)%\\Inno Setup 6\\ISCC.exe", "%LOCALAPPDATA%\\Programs\\Inno Setup 6\\ISCC.exe"], "winget": "JRSoftware.InnoSetup" },
    { "name": "Rust (stable MSVC)", "command": "rustup", "winget": "Rustlang.Rustup", "after": "rustup default stable-x86_64-pc-windows-msvc" }
  ],
  "steps": [ { "name": "tests + package + installer", "run": "powershell -NoProfile -ExecutionPolicy Bypass -File scripts\\build-release.ps1" } ],
  "artifacts": [ "out\\*-Setup.exe", "out\\*.zip" ],
  "deliver": "%USERPROFILE%\\Downloads"
}
Every step runs in the repo folder; a step fails the build when its exit code is not 0. Full log: %LOCALAPPDATA%\pbuild\logs\<name>.log
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][string]$Target,
    [switch]$Tools,
    [switch]$NoUpdate,
    [string]$SrcRoot = "$env:USERPROFILE\src"
)
$ErrorActionPreference = 'Stop'
$home_ = Join-Path $env:LOCALAPPDATA 'pbuild'
New-Item -ItemType Directory -Force -Path "$home_\logs" | Out-Null

function Step($m) { Write-Host "`n== $m" -ForegroundColor Cyan }
function Expand($s) { [Environment]::ExpandEnvironmentVariables($s) }
function RefreshPath { $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') + ";$env:USERPROFILE\.cargo\bin" }
# Runs a native command line with output shown and logged; stderr is text, only the exit code decides.
function Native([string]$Line, [string]$Cwd = (Get-Location).Path) {
    $old = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    Push-Location $Cwd
    try { & cmd.exe /d /s /c "$Line 2>&1" | ForEach-Object { "$_" } | Out-Host; return $LASTEXITCODE }
    finally { Pop-Location; $ErrorActionPreference = $old }
}
function ReadJson($path) {
    # build files may carry // comments
    $text = (Get-Content $path -Raw) -replace '(?m)^\s*//.*$', ''
    return $text | ConvertFrom-Json
}

# ---- resolve the build file
$repoDir = $null; $specPath = $null
if (Test-Path $Target) {
    $specPath = (Resolve-Path $Target).Path
    $repoDir = Split-Path $specPath -Parent
} elseif ($Target -match '^[\w.-]+/[\w.-]+$') {
    $repoDir = Join-Path $SrcRoot ($Target.Split('/')[1])
    $specPath = Join-Path $repoDir 'build.json'
} else { throw "pbuild: '$Target' is neither a build file nor owner/repo." }

$name = if (Test-Path $specPath) { (ReadJson $specPath).name } else { $Target.Split('/')[-1] }
$log = Join-Path "$home_\logs" (($name -replace '[^\w.-]', '_') + '.log')
$lockPath = Join-Path "$home_" (($name -replace '[^\w.-]', '_') + '.lock')
try { $lock = [IO.File]::Open($lockPath, 'OpenOrCreate', 'ReadWrite', 'None') } catch { Write-Host "pbuild: a build of $name is already running." -ForegroundColor Yellow; exit 1 }
Start-Transcript -Path $log -Force | Out-Null
trap { Write-Host "`nFAILED: $_" -ForegroundColor Red; Write-Host "Log: $log"; Stop-Transcript | Out-Null; $lock.Dispose(); exit 1 }

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'winget is missing: install "App Installer" from the Microsoft Store.' }
RefreshPath

# ---- source (git is needed before the build file can be read from a repo)
if ($Target -match '^[\w.-]+/[\w.-]+$') {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Step 'install Git'
        $c = Native 'winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements'
        RefreshPath
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git could not be installed (winget $c)" }
    }
    Step "source $Target"
    if (Test-Path "$repoDir\.git") {
        if (-not $NoUpdate) {
            if ((Native "git fetch origin" $repoDir) -ne 0) { throw 'git fetch failed' }
            $branch = if (Test-Path $specPath) { (ReadJson $specPath).branch } else { $null }
            if (-not $branch) { $branch = 'main' }
            if ((Native "git reset --hard origin/$branch" $repoDir) -ne 0) { throw 'git reset failed' }
        }
    } else {
        New-Item -ItemType Directory -Force -Path $SrcRoot | Out-Null
        # private repos: Git opens the browser to sign in the first time
        if ((Native "git clone https://github.com/$Target `"$repoDir`"") -ne 0) { throw 'git clone failed' }
    }
    Write-Host ("commit " + (git -C $repoDir log -1 --format='%h %s'))
}
if (-not (Test-Path $specPath)) { throw "No build file at $specPath" }
$spec = ReadJson $specPath
Write-Host "build file: $specPath"

# ---- tools
function ToolPresent($t) {
    if ($t.command) { if (-not (Get-Command $t.command -ErrorAction SilentlyContinue)) { return $false } }
    if ($t.check) {
        $out = (& cmd.exe /d /c "$($t.check) 2>nul") -join "`n"
        if ($LASTEXITCODE -ne 0) { return $false }
        if ($t.match -and -not ($out -split "`n" | Where-Object { $_ -match $t.match })) { return $false }
    }
    if ($t.paths) { if (-not ($t.paths | ForEach-Object { Expand $_ } | Where-Object { Test-Path $_ })) { return $false } }
    if ($t.vswhere) {
        $vsw = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
        if (-not (Test-Path $vsw)) { return $false }
        if (-not (& $vsw -products * -requires $t.vswhere -property installationPath)) { return $false }
    }
    return $true
}
Step 'tools'
foreach ($t in $spec.tools) {
    if (ToolPresent $t) { Write-Host "ok   $($t.name)"; continue }
    if (-not $t.winget) { throw "$($t.name) is missing and the build file gives no winget id." }
    Write-Host "install $($t.name) ($($t.winget))" -ForegroundColor Yellow
    if ($t.override) { Write-Host '(Windows may ask for administrator permission: answer Yes.)' -ForegroundColor Yellow }
    $line = "winget install --id $($t.winget) -e --accept-package-agreements --accept-source-agreements" + $(if ($t.override) { " --override `"$($t.override)`"" } else { ' --silent' })
    $code = Native $line
    RefreshPath
    if (-not (ToolPresent $t)) { throw "$($t.name) still missing after install (winget exit $code)." }
    Write-Host "ok   $($t.name) (installed)"
}
foreach ($t in $spec.tools | Where-Object { $_.after }) { if ((Native $t.after) -ne 0) { throw "'$($t.after)' failed" } }
if ($Tools) { Write-Host "`nTools ready." -ForegroundColor Green; Stop-Transcript | Out-Null; $lock.Dispose(); exit 0 }

# ---- steps
foreach ($s in $spec.steps) {
    Step $s.name
    $cwd = if ($s.cwd) { Join-Path $repoDir $s.cwd } else { $repoDir }
    $code = Native (Expand $s.run) $cwd
    if ($code -ne 0) { throw "step '$($s.name)' failed (exit $code)" }
}

# ---- artifacts
Step 'artifacts'
$dest = if ($spec.deliver) { Expand $spec.deliver } else { $null }
$found = @()
foreach ($a in $spec.artifacts) {
    $hit = Get-ChildItem (Join-Path $repoDir $a) -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $hit) { throw "artifact '$a' was not produced" }
    $found += $hit
}
foreach ($f in $found) {
    if ($dest) { Copy-Item $f.FullName $dest -Force; Write-Host "-> $(Join-Path $dest $f.Name)" -ForegroundColor Green }
    else { Write-Host "-> $($f.FullName)" -ForegroundColor Green }
}
Write-Host "`n$name built." -ForegroundColor Green
Stop-Transcript | Out-Null
$lock.Dispose()
