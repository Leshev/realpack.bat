chcp 65001
echo off
color 000A
title Install plugin realpack
mode con:cols=100 lines=11
rmdir /S /q realpack
md realpack
:start
powershell -Command "Invoke-WebRequest https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip -OutFile realpack\package.zip"
powershell -command "Expand-Archive -Force '%~dp0realpack\package.zip' '%~dp0realpack\'"
del realpack\package.zip