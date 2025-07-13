chcp 65001
echo off
title Install plugin realpack
rmdir /S /q realpack
md realpack

powershell -Command "Invoke-WebRequest https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip -OutFile realpack\package.zip"
powershell -command "Expand-Archive -Force '%~dp0realpack\package.zip' '%~dp0realpack\'"
del realpack\package.zip

setlocal enabledelayedexpansion

set "SOURCE_DIR=realpack"
set "TARGET_DIR=%USERPROFILE%\AppData\Roaming\MCGL\MinecraftLauncher2\repository\mclient\plugins"
set "TARGET_FOLDER=%TARGET_DIR%\realpack"

if not exist "%SOURCE_DIR%" (
 pause
 exit /b
)

if not exist "%TARGET_DIR%" (
 mkdir "%TARGET_DIR%"
 if not exist "%TARGET_DIR%" (
 pause
 exit /b
 )
)

if exist "%TARGET_FOLDER%" (
  rd /s /q "%TARGET_FOLDER%"
)

move "%SOURCE_DIR%" "%TARGET_DIR%"

cls
echo Успех!!! 
echo Complited!!!
timeout /t 3 >nul

