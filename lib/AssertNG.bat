@echo off
setlocal enabledelayedexpansion
REM ----------------------------------------------------------------------
REM - NAME   ) AssertOK
REM - DESC   ) Assertion when debug mode
REM -          if when not %2==%3, print value and pause
REM - USAGE  ) call :AssertOK Msg VarName ExpectVal
REM - IN/OUT )
REM -  IN   %1  : assert message
REM -  IN   %2  : variable name
REM -  IN   %3  : expect success value
REM -             if not match print msg and pause process
REM ----------------------------------------------------------------------
:AssertOK
if "%DEBUG_MODE%"=="1" (
    if not "!%2!"=="%~3" (
        echo [%1] %2:"!%2!", vs "%~3" >&2
        REM echo continue press any key
        pause >nul
    )
)
exit /b