Set objShell = CreateObject("Shell.Application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set objWshProcessEnv = objWshShell.Environment("PROCESS")

strPath = objWshShell.ExpandEnvironmentStrings( "%USERPROFILE%" )
strCommandLine = "/c " & strPath & "\presetup-b2d-win.cmd & pause"
strApplication = "cmd.exe"

objShell.ShellExecute strApplication, strCommandLine, "", "runas"