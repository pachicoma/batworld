@echo off
setlocal enabledelayedexpansion
REM ######################################################################
REM # [Description]
REM #  please write this batch script description...
REM # 
REM # [Usage]
REM #  BATNAME [/?]
REM # 
REM # [Params]
REM #   %1      : 
REM # 
REM # [Options]
REM #   /?      : Show Command Help
REM # 
REM ######################################################################
REM =================================================================
REM Enviroment Configs
REM =================================================================
REM  lib path append to %PATH%
REM ------------------------------------------------------------
set PATH=%~dp0lib;%PATH%
REM  set debug mode
REM ------------------------------------------------------------
set DEBUG_MODE=1

REM =================================================================
REM Initial Process
REM =================================================================
:INIT_PROCESS
set ERROR_MSG=""


REM =================================================================
REM Check Params 
REM =================================================================
REM ------------------------------------------------------------
REM  Options
REM ------------------------------------------------------------
:ANALYZE_OPTIONS
if "%~1"=="" goto :ANALYZE_PARAMS
set ParamTemp=%~1
set OptType=%ParamTemp:~1,1%
if "%ParamTemp:~0,1%"=="/" (
    if "%OptType%"=="?" (
        goto :USAGE
    ) else (
        set ERROR_MSG='%OptType%' is Unknown Option
        goto :ERROR_HELP_EXIT
    )
    shift
    goto :ANALYZE_OPTIONS
)

REM ------------------------------------------------------------
REM  Params
REM ------------------------------------------------------------
:ANALYZE_PARAMS
if "%~1"=="" (
    REM no given param
    set ERROR_MSG=No given parameter
    goto :ERROR_HELP_EXIT
) else (
    REM given param
    call :DEBUG_ECHO Param1 ParamTemp
)


REM =================================================================
REM Main Process
REM =================================================================
:MAIN_PROCESS


REM =================================================================
REM Exit Process
REM =================================================================
REM  Success Process Exit
REM ------------------------------------------------------------
:EXIT_SUCCESS
endlocal
exit /b 0

REM  Faild Process Exit
REM ------------------------------------------------------------
:EXIT_FAILD
endlocal
exit /b 1


REM =================================================================
REM Sub Process
REM =================================================================
REM  Print usage and exit
REM ------------------------------------------------------------
:USAGE
call :SHOW_HELP
goto :EXIT_SUCCESS

REM  Print message and help and exit
REM ------------------------------------------------------------
:ERROR_HELP_EXIT
echo %ERROR_MSG%
echo.
call :SHOW_HELP
goto :EXIT_FAILD

REM =================================================================
REM Common Functions (only used by this command)
REM =================================================================
REM ------------------------------------------------------------
REM - Name  ) SHOW_HELP
REM - Desc  ) Show Help this command. 
REM -         Print only start of line is "REM # " in this file
REM - Usage ) call :SHOW_HELP
REM ------------------------------------------------------------
:SHOW_HELP
for /f "tokens=2*delims=#" %%a in ('findstr /b /c:"REM # " ^<%~nx0') do (
    set lineText=%%a
    set lineText=!lineText:BATNAME=%~nx0!
    echo.!lineText!
)
exit /b

REM ------------------------------------------------------------
REM - Name  ) DEBUG_ECHO
REM - Desc  ) Echo "VarName:VarValue" when only debug mode
REM - Usage ) call :DEBUG_ECHO [DebugMsg] VarName
REM -   %1  ) debug message or variable name
REM -  [%2] ) variable name (only given debug message for %1) 
REM ------------------------------------------------------------
:DEBUG_ECHO
if "%DEBUG_MODE%"=="1" (
    if "%~2"=="" (
        echo %1:!%1!
    ) else (
        echo [%1] %2:!%2!
    )
)
exit /b

REM ------------------------------------------------------------
REM - Name  ) ASSERT_OK
REM - Desc  ) Assertion when debug mode
REM -         if when not %2==%3, print value and pause
REM - Usage ) call :ASSERT_OK Message VarName ExpectOKVal
REM -   %1  ) assert message
REM -   %2  ) variable name
REM -   %3  ) expect success value
REM ------------------------------------------------------------
:ASSERT_OK
if "%DEBUG_MODE%"=="1" (
    if not "!%2!"=="%~3" (
        echo [%1] %2:"!%2!" is not "%~3"
        REM echo continue press any key
        pause >nul
    )
)
exit /b

REM ------------------------------------------------------------
REM - Name  ) ASSERT_NG
REM - Desc  ) Assertion when debug mode
REM - if when %2==%3, print value and pause
REM - Usage ) call :ASSERT_NG Message VarName ExpectNGVal
REM -   %1  ) assert message
REM -   %2  ) variable name
REM -   %3  ) expect error value
REM ------------------------------------------------------------
:ASSERT_NG
if "%DEBUG_MODE%"=="1" (
    if "!%2!"=="%~3" (
        echo [%1] %2:"!%2!" is "%~3"
        REM echo continue press any key
        pause >nul
    )
)
exit /b
