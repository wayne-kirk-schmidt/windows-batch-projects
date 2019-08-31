@echo off
setlocal enableDelayedExpansion

::  This is an example of how to keep a help message within batch
::  Each of the options can be setup within the batch enviroment.
::      Option:  /? -- Help Message. Print this message
::      Option:  /v -- Increase verbosity of this script

set myfile=%~f0

IF [%1]==[/?] GOTO :HelpMessage

echo %* | find "/?" > nul
IF errorlevel 1 GOTO :MainCode

:MainCode
echo We got here
GOTO :end

:HelpMessage
for /F "delims=" %%a in ('type %myfile% ^| findstr "^::  "') do ( 
	 REM echo %%a
	 SET LINE=%%a
	 SET _stripped=!LINE:~2!
	 ECHO !_stripped! 
)
GOTO :End

:End
