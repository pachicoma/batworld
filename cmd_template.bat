@echo off
setlocal enabledelayedexpansion
REM ###########################################################################
REM # [DESCRIPTION]
REM #  please write this batch script description...
REM # 
REM # [VERSION] 0.01
REM # [USAGE]   %~nx0 [/?]
REM # [PARAMS]
REM #   %1      : 
REM # 
REM # [OPTIONS]
REM #   /?      : Show command help
REM #   /V      : Show command version
REM #   /U      : Set output encode 'UTF8'
REM # 
REM ###########################################################################
REM ======================================================================
REM = Enviroment Configs
REM ======================================================================
REM  lib path append to %PATH%
REM ----------------------------------------
set PATH=%~dp0lib;%PATH%

REM  if set 1, enable debug mode
REM ----------------------------------------
set DEBUG_MODE=1

REM ======================================================================
REM = Initial Process
REM ======================================================================
:INIT_PROCESS
set ERROR_MSG=""


REM ======================================================================
REM = Check Command Params 
REM ======================================================================
REM  Options
REM ----------------------------------------
set PATH=%~dp0lib;%PATH%
:ANALYZE_OPTIONS
if "%~1"=="" goto :ANALYZE_PARAMS
set ParamTemp=%~1
set OptType=%ParamTemp:~1,1%
if "%ParamTemp:~0,1%"=="/" (
    if "%OptType%"=="?" (
        goto :SHOW_HELP
    ) else if "%OptType%"=="V" (
        goto :SHOW_VERSION
    ) else if "%OptType%"=="U" (
        REM set code page UTF8
        chcp 65001 >nul
    ) else (
        set ERROR_MSG='%OptType%' is Unknown Option
        goto :ERROR_HELP_EXIT
    )
    shift
    goto :ANALYZE_OPTIONS
)

REM  Params
REM ----------------------------------------
:ANALYZE_PARAMS
if "%~1"=="" (
    REM no given param
    set ERROR_MSG=No given parameter
    goto :ERROR_HELP_EXIT
) else (
    REM given param
    call :DebugMsg DebugMsg ParamTemp
    call :AssertOK AssertOK ParamTemp OK
    call :AssertNG AssertNG ParamTemp NG
)


REM ======================================================================
REM = Main Process
REM ======================================================================
:MAIN_PROCESS


REM ======================================================================
REM = Exit Process
REM ======================================================================
REM  Success Process Exit
REM ----------------------------------------
:EXIT_SUCCESS
endlocal
exit /b 0

REM  Faild Process Exit
REM ----------------------------------------
:EXIT_FAILD
endlocal
exit /b 1


REM ======================================================================
REM = Sub Process
REM ======================================================================
REM  Print usage and exit
REM ----------------------------------------
:SHOW_HELP
call :PrintHelp
goto :EXIT_SUCCESS

REM  Print usage and exit
REM ----------------------------------------
:SHOW_VERSION
call :PrintVersion
goto :EXIT_SUCCESS

REM  Print message and help and exit
REM ----------------------------------------
:ERROR_HELP_EXIT
echo %ERROR_MSG%
echo.
call :PrintHelp
goto :EXIT_FAILD

REM ======================================================================
REM = Common Functions (only used by this command)
REM ======================================================================
REM ----------------------------------------------------------------------
REM - NAME   ) PrintHelp
REM - DESC   ) Print Help this command. 
REM -          Print only start of line is "REM # " in this file
REM - USAGE  ) call :PrintHelp
REM ----------------------------------------------------------------------
:PrintHelp
for /f "tokens=2* delims=#" %%a in ('findstr /b /c:"REM # " ^<%~nx0') do (
    set lineText=%%a
    REM replace batch filename
    set lineText=!lineText:%%~nx0=%~nx0!
    echo.!lineText!
)
exit /b

REM ----------------------------------------------------------------------
REM - NAME   ) PrintVersion
REM - DESC   ) Print Version this command. 
REM -          Print only start of line is "REM # [VERSION]" in this file
REM - USAGE  ) call :PRINT_VERSION
REM ----------------------------------------------------------------------
:PrintVersion
for /f "tokens=4* delims= " %%a in ('findstr /b /c:"REM # [VERSION]" ^<%~nx0') do (
    echo %%a
)
exit /b

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

REM ----------------------------------------------------------------------
REM - NAME   ) AssertNG
REM - DESC   ) Assertion when debug mode
REM -          if when %2==%3, print value and pause
REM - USAGE  ) call :AssertNG Msg VarName ExpectVal
REM - IN/OUT )
REM -  IN   %1  : assert message
REM -  IN   %2  : variable name
REM -  IN   %3  : expect error value
REM -             if match print msg and pause process
REM ----------------------------------------------------------------------
:AssertNG
if "%DEBUG_MODE%"=="1" (
    if "!%2!"=="%~3" (
        echo [%1] %2:"!%2!" !vs "%~3" >&2
        REM echo continue press any key
        pause >nul
    )
)
exit /b
