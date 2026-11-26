@echo off
rem pbuild launcher: pbuild owner/repo | pbuild path\to\build.json [-Tools] [-NoUpdate]
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0pbuild.ps1" %*
