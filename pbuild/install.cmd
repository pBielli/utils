@echo off
rem Double-click: installs the pbuild command for this user.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
pause
