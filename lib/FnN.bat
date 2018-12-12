@echo off
REM setlocal enabledelayedexpansion
REM ----------------------------------------------------------------------
REM - NAME   ) FnN
REM - DESC   ) set command output values to array
REM - USAGE  ) call FnN CmdName ArrName
REM - IN/OUT )
REM -  IN   %1  : call command name, return value must be output to stdout
REM -  IN   %2  : output array name
REM -             when given 'A', set to A[0],A[1],...
REM ----------------------------------------------------------------------
:FnN
set _FnN_n=0
for /f "usebackq tokens=* delims=" %%a in (`%~1`) do (
    set %~2[!_FnN_n!]=%%a
    set /a _FnN_n=_FnN_n+1
)
exit /b %_FnN_n%
