# pbuild

One command builds any pBielli app on a Windows PC, no CI needed.

```
install.cmd                          (once: adds `pbuild` to your PATH)
pbuild pBielli/switchboard           clone/update + tools + build + copy artifacts
pbuild C:\src\app\build.json         build a local checkout
pbuild pBielli/switchboard -Tools    only check/install the tools
pbuild pBielli/switchboard -NoUpdate build what is on disk
```

Each app keeps a `build.json` in its repo root: tools (checked, installed with winget when missing), steps (run in the
repo folder, fail on non-zero exit), artifacts (copied to `deliver`). See the header of `pbuild.ps1` for the format.
Log of the last run: `%LOCALAPPDATA%\pbuild\logs\<name>.log`. One build per app at a time.
