@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "OUTPUT_FILE=LOR.md"
set "START_DIR=Timeline"

break > "%OUTPUT_FILE%"

call :ProcessDirectory "%START_DIR%" 1

echo(
echo Done.
echo Output: %OUTPUT_FILE%
exit /b


:ProcessDirectory

setlocal EnableDelayedExpansion

set "DIR_PATH=%~1"
set /a LEVEL=%~2

rem Build markdown header prefix
set "PREFIX="

for /l %%i in (1,1,%LEVEL%) do (
    set "PREFIX=!PREFIX!#"
)

rem Get directory name
for %%D in ("%DIR_PATH%") do (
    set "DIR_NAME=%%~nxD"
)

rem Remove numeric prefix before first dot
set "CLEAN_NAME=!DIR_NAME!"

for /f "tokens=1* delims=." %%a in ("!DIR_NAME!") do (
    if not "%%b"=="" (
        set "CLEAN_NAME=%%b"
    )
)

echo !PREFIX! !CLEAN_NAME!>> "%OUTPUT_FILE%"
echo(>> "%OUTPUT_FILE%"

rem Output _index.md
set "INDEX_FILE=%DIR_PATH%\_index.md"

if exist "!INDEX_FILE!" (

    echo File: !INDEX_FILE!>> "%OUTPUT_FILE%"
    echo(>> "%OUTPUT_FILE%"

    type "!INDEX_FILE!" >> "%OUTPUT_FILE%"

    echo(>> "%OUTPUT_FILE%"
    echo(>> "%OUTPUT_FILE%"
)

rem Process subdirectories
set /a NEXT_LEVEL=%LEVEL%+1

for /d %%D in ("%DIR_PATH%\*") do (
    call :ProcessDirectory "%%D" !NEXT_LEVEL!
)

rem Process files
for %%F in ("%DIR_PATH%\*") do (

    if /i not "%%~nxF"=="_index.md" (

        if not "%%~aF"=="d" (

            set "CLEAN_FILENAME=%%~nF"

            for /f "tokens=1* delims=." %%a in ("%%~nF") do (
                if not "%%b"=="" (
                    set "CLEAN_FILENAME=%%b"
                )
            )

            echo !PREFIX! !CLEAN_FILENAME!>> "%OUTPUT_FILE%"
            echo(>> "%OUTPUT_FILE%"

            echo File: %%F>> "%OUTPUT_FILE%"
            echo(>> "%OUTPUT_FILE%"

            type "%%F" >> "%OUTPUT_FILE%"

            echo(>> "%OUTPUT_FILE%"
            echo(>> "%OUTPUT_FILE%"
        )
    )
)

endlocal
exit /b