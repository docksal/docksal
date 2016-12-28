@echo off
setlocal enableextensions enabledelayedexpansion

set SCRIPT_PATH=%~dp0
set SCRIPT_PATH=%SCRIPT_PATH:\=/%
set BABUN_HOME=%SCRIPT_PATH%
set CHERE_INVOKING=1
set CYGWIN_HOME=%BABUN_HOME%\cygwin

start "" "%CYGWIN_HOME%\bin\bash.exe" --login
