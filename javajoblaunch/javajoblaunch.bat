::::
:::: ------------------------------------------
:::: This is the property of Molson Coors Japan
:::: ------------------------------------------
::::
:::: Launcher script:
:::: Author: "Wayne Schmidt" <wayne.kirk.schmidt@gmail.com>
::::
:::: Usage: 
::::	<script> /?             -- prints this help file
::::	<script> <configfile>   -- launches this script
::::  
@echo OFF
setlocal enableDelayedExpansion

set MyFile=%~f0

if [%1]==[/?] goto :HelpMessage

echo %* |find "/?" > nul
if errorlevel 1 goto :MainCode

:HelpMessage
for /F "delims=" %%a in ('type %MyFile% ^| findstr "^::::"') do ( 
	 set LINE=%%a
	 set _stripped=!LINE:~2!
	 echo !_stripped!
)
goto :End

:MainCode

:: Collect the configuration file for the job
:: Using only 1 input, and relying on the config file to bootstrap the rest
set configfile=%~dfp1
if not exist %configfile% exit /b

:: Set Environment Variables from Supplied Configuration File
for /f "delims== tokens=1,2" %%G in (%configfile%) do set %%G=%%H

:: Populate Array of Jars from the JOB_jarlist for the job
set index=0
for %%A in (%JOB_jarlist%) do (
    set Array[!index!] = %%A
    set /a index += 1
)

:: Test for all of the directory existence
for /D %%D in ( %JOB_basedir% %JOB_logdir% %JOB_datadir% ) do (
    PUSHD %%D && POPD || (
        ECHO %%D does NOT exist
	    exit /b
	)
)

:: Set Time and Date variables
for /f %%X in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%X

:: Fix up time variables if they are single digit
IF %Month%  LSS 10 SET Day=0%Month%
IF %Day%    LSS 10 SET Day=0%Day%
IF %Hour%   LSS 10 SET Day=0%Hour%
IF %Minute% LSS 10 SET Day=0%Minute%

:: Set variables for the error and output files
set DateStamp=%Year%%Month%%Day%
set TimeStamp=%Hour%%Minute%
set LogStamp=%DateStamp%.%TimeStamp%

set JobName=%JOB_jobname%

:: Output Commands necessary to execute the job. 
for /F "tokens=2 delims==" %%S in ('set Array[') do (
    setlocal enabledelayedexpansion
	set String=%%~nS
    set String=!String: =!
	set ErrFile=%JOB_logdir%\%JobName%.!String!.%LogStamp%.err.txt
	set Outfile=%JOB_logdir%\%JobName%.!String!.%LogStamp%.out.txt
	echo "cmd /u /e:on /f:on /v:on !JOB_basedir!\!String!.jar > !OutFile! 2> !ErrFile!"
) 

GOTO :End

:End
