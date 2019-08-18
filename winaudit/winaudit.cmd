::::
:::: Launcher script:
:::: Author: "Wayne Schmidt" <wayne.kirk.schmidt@gmail.com>
::::
::::
:::: Usage: 
::::	<script> /?             -- prints this help file
::::	<script> <configfile>   -- launches this script
::::  
@echo OFF
setlocal enableDelayedExpansion
chcp 65001

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

set JobName=WinAudit

set TMPDIR=C:\Windows\Temp\%COMPUTERNAME%
mkdir %TMPDIR% 2>null

set ERRDIR=C:\Windows\Temp\%COMPUTERNAME%\err
rmdir %ERRDIR% /S /Q
mkdir %ERRDIR%

set LOGDIR=C:\Windows\Temp\%COMPUTERNAME%\log
rmdir %LOGDIR% /S /Q
mkdir %LOGDIR%

:: Set Environment Variables from Supplied Configuration File
for /f "delims== tokens=1,2" %%G in (%configfile%) do (
	set outfile=%LOGDIR%\%COMPUTERNAME%.%%G.csv
	set errfile=%ERRDIR%\%COMPUTERNAME%.%%G.err
	set outputcmds=%%H
	echo Collecting: %%G
	echo Using: !outputcmds!
	@cmd /C ^( !outputcmds! ^> !outfile! 2^> !errfile! ^)
)

GOTO :End

:End


	 
	 