chcp 65001
echo off
mode con:cols=20 lines=2
title Install plugin realpack 3.4
rmdir /S /q realpack
md realpack
cls
echo Download...
powershell -Command "Invoke-WebRequest https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip -OutFile realpack\package.zip"
cls
echo Install...
powershell -command "Expand-Archive -Force '%~dp0realpack\package.zip' '%~dp0realpack\'"
del realpack\package.zip
cls
echo Complited!
timeout /t 2 >nul
exit

