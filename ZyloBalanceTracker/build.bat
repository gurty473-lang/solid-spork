@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

set GRADLE_VERSION=9.2.1
set GRADLE_DIR=%~dp0.gradle-dist
set GRADLE_HOME_LOCAL=%GRADLE_DIR%\gradle-%GRADLE_VERSION%

echo ==== Zylo Balance Tracker - build ====

rem ---- 1. Check Java 21+ ----
where java >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Java was not found. Install JDK 21 ^(e.g. Temurin: https://adoptium.net^) and re-run.
    goto :fail
)
set JAVA_MAJOR=0
for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JV=%%~v
)
for /f "delims=.-" %%m in ("!JV!") do set JAVA_MAJOR=%%m
if !JAVA_MAJOR! LSS 21 (
    echo [ERROR] Java !JV! detected, but Java 21 or newer is required.
    goto :fail
)
echo Java !JV! OK

rem ---- 2. Pick a Gradle: wrapper > local download > system ----
set GRADLE_CMD=
if exist "gradle\wrapper\gradle-wrapper.jar" (
    set GRADLE_CMD=call gradlew.bat
    goto :run
)
if exist "%GRADLE_HOME_LOCAL%\bin\gradle.bat" (
    set GRADLE_CMD="%GRADLE_HOME_LOCAL%\bin\gradle.bat"
    goto :run
)
where gradle >nul 2>nul
if not errorlevel 1 (
    set GRADLE_CMD=gradle
    goto :run
)

echo Gradle not found - downloading Gradle %GRADLE_VERSION% ...
if not exist "%GRADLE_DIR%" mkdir "%GRADLE_DIR%"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " ^
  "Invoke-WebRequest -UseBasicParsing 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%GRADLE_DIR%\gradle.zip'; " ^
  "Expand-Archive -Force '%GRADLE_DIR%\gradle.zip' '%GRADLE_DIR%'; " ^
  "Remove-Item '%GRADLE_DIR%\gradle.zip'"
if not exist "%GRADLE_HOME_LOCAL%\bin\gradle.bat" (
    echo [ERROR] Gradle download failed. Check your internet connection.
    goto :fail
)
set GRADLE_CMD="%GRADLE_HOME_LOCAL%\bin\gradle.bat"

rem ---- 3. Generate the Gradle wrapper once so IntelliJ / gradlew work too ----
echo Creating Gradle wrapper ...
call %GRADLE_CMD% wrapper --gradle-version %GRADLE_VERSION% --no-daemon

:run
echo.
echo Building mod jar ...
%GRADLE_CMD% build --no-daemon
if errorlevel 1 goto :fail

echo.
echo ==== BUILD SUCCESSFUL ====
echo Your mod jar is in: %~dp0build\libs\
dir /b "build\libs\*.jar" 2>nul
echo.
echo Use zylo-balance-tracker-*.jar ^(NOT the -sources jar^) in .minecraft\mods together with Fabric API.
if exist "build\libs" explorer "build\libs"
pause
exit /b 0

:fail
echo.
echo ==== BUILD FAILED ====
pause
exit /b 1
