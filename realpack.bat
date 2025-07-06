chcp 65001
echo off
color 000A
title Install plugin realpack
mode con:cols=100 lines=11
rmdir /S /q realpack
md realpack
cls
echo Download realpack in GitHub by Leshev
powershell -Command "Invoke-WebRequest https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip -OutFile realpack\package.zip"
cls
echo Instal files
powershell -command "Expand-Archive -Force '%~dp0realpack\package.zip' '%~dp0realpack\'"
del realpack\package.zip
cls
echo Complited!
timeout /t 2 >nul
exit
