@echo off
setlocal enabledelayedexpansion
REM ----------------------------------------------------------------------
REM - NAME   ) Each
REM - DESC   ) call func each of array
REM - USAGE  ) call Each AryName ArySize CmdName [AfterParams]
REM - IN/OUT )
REM -  IN   %1  : source array name
REM -  IN   %2  : source array size
REM -  IN   %3  : apply command name, each of array elements
REM -  IN   %4  : command append parameters,
REM -             call format) call ApplyCmd OutCmdOutput AfterParamas
REM ----------------------------------------------------------------------
:Each
set /a _Each_End=%2-1
set _Each_ExitStatus=0
for /l %%i in (0, 1, %_Each_End%) do (
    call %~3 !%~1[%%i]! %~4
    if not "%ERRORLEVEL%"=="0" (
        set _Each_ExitStatus=1
    )
)
exit /b %_Each_ExitStatus%