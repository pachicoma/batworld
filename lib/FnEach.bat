@echo off
setlocal enabledelayedexpansion
REM ----------------------------------------------------------------------
REM - NAME   ) FnEach
REM - DESC   ) command1 output values apply command2
REM - USAGE  ) call FnEach OutCmdName ApplyCmdName [AfterParams]
REM - IN/OUT )
REM -  IN   %1  : call command name, return value must be output to stdout
REM -  IN   %2  : apply command name, each of array elements
REM -  IN   %3  : command params, after elements
REM -             call format) call ApplyCmd OutCmdOutput AfterParamas
REM ----------------------------------------------------------------------
:FnEach
set _FnEach_ExitStatus=0
for /f "usebackq tokens=* delims=" %%a in (`%~1`) do (
    call %~2 %%a %~3
    if not "!ERRORLEVEL!"=="0" (
        set _FnEach_ExitStatus=1
    )
)
exit /b %_FnEach_ExitStatus%
