REM Installing Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

REM Installing virtualbox, vagrant, docker
choco install virtualbox -y
choco install vagrant -y
choco install docker -y
