chcp 65001
echo off
color 000A
title RealPack 
mode con:cols=55 lines=11

:start
cls
echo ====================================================
echo ====   Добро пожаловать в установщик RealPack   ====
echo ====================================================
echo 1 Установить.
echo 2 Обновить.
set /p result=
if %result% EQU 2 (goto :update) else if %result% EQU 1 (goto install)




:install
cls
setlocal enabledelayedexpansion

set "SOURCE_DIR=realpack"
set "TARGET_DIR=%USERPROFILE%\AppData\Roaming\MCGL\MinecraftLauncher2\repository\mclient\plugins"
set "TARGET_FOLDER=%TARGET_DIR%\realpack"

:: Проверка наличия PowerShell
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo Для работы скрипта требуется PowerShell.
    pause
    exit /b 1
)

set "zip_url=https://github.com/Leshev/realpack/raw/refs/heads/main/realpack.zip"
set "zip_file=realpack.zip"
set "extract_dir=realpack"

echo Скачивание архива...
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%zip_url%' -OutFile '%zip_file%'"

if not exist "%zip_file%" (
    echo Ошибка при скачивании архива.
    pause
    exit /b 1
)

echo Создание папки для распаковки...
if not exist "%extract_dir%" (
    mkdir "%extract_dir%"
) else (
    echo Папка "%extract_dir%" уже существует. Удаление содержимого...
    del /q "%extract_dir%\*" >nul 2>&1
    rmdir /s /q "%extract_dir%" >nul 2>&1
    mkdir "%extract_dir%"
)

echo Распаковка архива...
:: Используем PowerShell для распаковки
powershell -command "Expand-Archive -Path '%zip_file%' -DestinationPath '%extract_dir%'"

if %errorlevel% neq 0 (
    echo Ошибка при распаковке архива.
    pause
    exit /b 1
)

echo Удаление временного архива...
del "%zip_file%"

echo Архив успешно скачан и распакован в папку "%extract_dir%".
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

if exist "%TARGET_FOLDER%" (
 echo Папка realpack успешно перемещена в %TARGET_DIR%
) else (
 echo Ошибка при перемещении папки
)
cls
echo Установка завершена.



:update
cls

where powershell >nul 2>&1
if %errorlevel% neq 0 (
		echo Установка пакетов PowerShell и Winget...
		winget install --id Microsoft.Powershell --source winget >nul
		echo Успешно!
		)

echo Проверяю обновления...
setlocal enabledelayedexpansion

:: Путь к локальному файлу version.txt
set "TARGET_DIR=%USERPROFILE%\AppData\Roaming\MCGL\MinecraftLauncher2\repository\mclient\plugins\realpack"
set "LOCAL_VERSION_FILE=%TARGET_DIR%\version.txt"

:: URL для скачивания версии с GitHub
set "GITHUB_VERSION_URL=https://github.com/Leshev/realpack/raw/refs/heads/main/version.txt"

:: Временный файл для хранения версии с GitHub
set "TEMP_VERSION_FILE=%TEMP%\github_version.txt"

:: Проверяем существование локального файла версии
if not exist "%LOCAL_VERSION_FILE%" (
    echo Локальный файл версии не найден: %LOCAL_VERSION_FILE%
    goto :end
)

:: Проверяем наличие curl
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo Ошибка: curl не установлен или не добавлен в PATH
    echo Устанавливаю...
	winget install --id=cURL.cURL -e >nul
)
:: Скачиваем версию с GitHub с помощью curl
echo Проверяем актуальную версию на GitHub...
curl -L -s -o "%TEMP_VERSION_FILE%" "%GITHUB_VERSION_URL%"

if not exist "%TEMP_VERSION_FILE%" (
    echo Не удалось загрузить версию с GitHub
    goto :end
)

:: Читаем версии
set /p LOCAL_VERSION=<"%LOCAL_VERSION_FILE%"
set /p GITHUB_VERSION=<"%TEMP_VERSION_FILE%"

:: Удаляем временный файл
del "%TEMP_VERSION_FILE%" >nul 2>&1

echo Локальная версия:    %LOCAL_VERSION%
echo Версия на GitHub:    %GITHUB_VERSION%
:: Сравниваем версии
if "%LOCAL_VERSION%"=="%GITHUB_VERSION%" (
    echo Версии совпадают. Обновление не требуется.
	echo Завершаю работу...
	timeout /t 5 
	exit /b
) else (
    echo Доступна новая версия: %GITHUB_VERSION%
	echo Обновляю...
	goto install
	exit /b
)


:end
	echo Завершаю работу...
	timeout /t 5 
	exit /b
