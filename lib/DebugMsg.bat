@echo off
setlocal enabledelayedexpansion
REM ----------------------------------------------------------------------
REM - NAME   ) DebugMsg
REM - DESC   ) Print "VarName:VarValue" when only debug mode
REM - USAGE  ) call :DebugMsg [DebugMsg] VarName
REM - IN/OUT )
REM -  IN  [%1] : debug message
REM -  IN   %2  : variable name
REM ----------------------------------------------------------------------
:DebugMsg
if "%DEBUG_MODE%"=="1" (
    if "%~2"=="" (
        echo %1:!%1! >&2
    ) else (
        echo [%1] %2:!%2! >&2
    )
)
exit /b
