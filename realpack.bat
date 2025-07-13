@echo off
chcp 65001 >nul
title Установка плагина realpack

setlocal enabledelayedexpansion

set "SOURCE_DIR=realpack"
set "TARGET_DIR=%USERPROFILE%\AppData\Roaming\MCGL\MinecraftLauncher2\repository\mclient\plugins"
set "TARGET_FOLDER=%TARGET_DIR%\realpack"
set "DOWNLOAD_URL=https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip"
set "TEMP_ZIP=%TEMP%\realpack_temp.zip"


rmdir /S /Q "%SOURCE_DIR%" >nul 2>&1

echo Попытка скачивания через bitsadmin
bitsadmin /transfer "RealPackDownload" /download /priority normal "%DOWNLOAD_URL%" "%TEMP_ZIP%" >nul
if errorlevel 1 (
    echo Ошибка при скачивании через bitsadmin
    echo Попытка скачивания через PowerShell
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%')" >nul
    if errorlevel 1 (
        echo Ошибка при скачивании через PowerShell
        pause
        exit /b
    )
)

echo Проверяем наличие 7-Zip
where 7z >nul 2>&1
if %errorlevel% equ 0 (
    echo Распаковка через 7-Zip
    mkdir "%SOURCE_DIR%" >nul
    7z x "%TEMP_ZIP%" -o"%SOURCE_DIR%" >nul
) else (
    echo Распаковка через PowerShell (если 7-Zip не найден)
    powershell -Command "Expand-Archive -Force '%TEMP_ZIP%' '%SOURCE_DIR%'" >nul
)

if errorlevel 1 (
    echo Ошибка распаковки архива
    pause
    exit /b
)

echo Удаляем временный zip файл
del "%TEMP_ZIP%" >nul

echo Создаем целевую директорию если не существует
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%" >nul
    if not exist "%TARGET_DIR%" (
        echo Ошибка создания целевой директории
        pause
        exit /b
    )
)

echo Копируем новые файлы, заменяя существующие
xcopy /s /y /q "%SOURCE_DIR%\*" "%TARGET_FOLDER%" >nul
if not exist "%TARGET_FOLDER%" (
    echo Ошибка при копировании файлов
    pause
    exit /b
)

echo Удаляем временную директорию
rmdir /S /Q "%SOURCE_DIR%" >nul

echo Установка завершена успешно!
echo Плагин realpack обновлен в %TARGET_FOLDER%
pause
