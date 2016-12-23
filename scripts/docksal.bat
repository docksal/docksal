@echo off
setlocal enableextensions enabledelayedexpansion

set SCRIPT_PATH=%~dp0
set SCRIPT_PATH=%SCRIPT_PATH:\=/%
set BABUN_HOME=%SCRIPT_PATH%
set CHERE_INVOKING=1

:BEGIN
set CYGWIN_HOME=%BABUN_HOME%\cygwin
if exist "%CYGWIN_HOME%\bin\zsh.exe" goto RUN
if not exist "%CYGWIN_HOME%\bin\zsh.exe" goto NOTFOUND

:RUN
ECHO [babun] Starting babun
start "" "%CYGWIN_HOME%\bin\zsh.exe" --login || goto :ERROR
GOTO END

:NOTFOUND
ECHO [babun] Start script not found. Babun installation seems to be corrupted.
EXIT /b 255

:ERROR
ECHO [babun] Terminating due to internal error #%errorlevel%
EXIT /b %errorlevel%

:END
