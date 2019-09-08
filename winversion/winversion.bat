@echo off
setlocal enabledelayedexpansion
set workstation[4.0.950]=Windows_95
set workstation[4.0.950A]=Windows_95_OEM_Service_Release_1
set workstation[4.0.950B]=Windows_95_OEM_Service_Release_2
set workstation[4.0.950B]=Windows_95_OEM_Service_Release_2.1
set workstation[4.0.950C]=Windows_95_OEM_Service_Release_2.5
set workstation[4.1.1998]=Windows_98
set workstation[SE.4.1]=Windows_98_Second_Edition
set workstation[4.9.3000]=Windows_Me
set workstation[3.1.511]=Windows_NT_3.1
set workstation[3.1.528]=Windows_NT_3.1_Service_Pack_3
set workstation[3.5.807]=Windows_NT_3.5
set workstation[3.5.1057]=Windows_NT_3.51
set workstation[4.0.1381]=Windows_NT_4.0
set workstation[5.0.2195]=Windows_2000
set workstation[5.1.2600]=Windows_XP
set workstation[5.1.2600.1105-1106]=Windows_XP_Service_Pack_1
set workstation[5.1.2600.218]=Windows_XP_Service_Pack_2
set workstation[5.1.2600]=Windows_XP_Service_Pack_3
set workstation[6.0.6000]=Windows_Vista
set workstation[6.0.6001]=Windows_Vista_Service_Pack_1
set workstation[6.0.6002]=Windows_Vista_Service_Pack_2
set workstation[6.1.7600]=Windows_7
set workstation[6.1.7601]=Windows_7_Service_Pack_1
set workstation[6.2.9200]=Windows_8
set workstation[6.3.9600]=Windows_8.1
set workstation[10.0.10240]=Windows_10_Version_1507
set workstation[10.0.10586]=Windows_10_Version_1511
set workstation[10.0.14393]=Windows_10_Version_1607
set workstation[10.0.15063]=Windows_10_Version_1703
set workstation[10.0.16299]=Windows_10_Version_1709
set workstation[10.0.17134]=Windows_10_Version_1803
set workstation[10.0.17763]=Windows_10_Version_1809
set workstation[10.0.18362]=Windows_10_Version_1903

set serveros[3.1.511]=Windows_NT_3.1
set serveros[3.1.528]=Windows_NT_3.1_Service_Pack_3
set serveros[3.5.807]=Windows_NT_3.5
set serveros[3.5.1057]=Windows_NT_3.51
set serveros[4.0.1381]=Windows_NT_4.0
set serveros[5.2.3790]=Windows_Server_2003
set serveros[5.2.3790.118]=Windows_Server_2003_Service_Pack_1
set serveros[5.2.3790.1]=Windows_Server_2003_Service_Pack_2
set serveros[5.2.3790.2]=Windows_Server_2003_R2
set serveros[5.2.4500]=Windows_Home_Server
set serveros[6.0.6001]=Windows_Server_2008
set serveros[6.0.6002]=Windows_Server_2008_Service_Pack_2
set serveros[6.0.6003]=Windows_Server_2008_Service_Pack_2_Rollup_KB4489887
set serveros[6.1.7600]=Windows_Server_2008_R2
set serveros[6.1.7601]=Windows_Server_2008_R2_Service_Pack_1
set serveros[6.1.8400]=Windows_Home_Server_2011
set serveros[6.2.9200]=Windows_Server_2012
set serveros[6.3.9600]=Windows_Server_2012_R2
set serveros[10.0.14393]=Windows_Server_2016_Version_1607
set serveros[10.0.16299]=Windows_Server_2016_Version_1709
set serveros[10.0.17763]=Windows_Server_2019_Version_1809

for /F "tokens=2,3 delims=[]=" %%a in ('set serveros') do (
   set "serveros=!serveros:%%a=%%b!"
)

for /F "tokens=2,3 delims=[]=" %%a in ('set workstation') do (
   set "workstation=!workstation:%%a=%%b!"
)

for /f "tokens=4-8 delims=. " %%i in ('ver') do set VERSION=%%i.%%j.%%k
set version=!version:]=!

echo VersionNumber: %version%

for /F "tokens=4" %%a in ( 'systeminfo ^| findstr /B /C:"OS Configuration"' ) do set BUILDTYPE=%%a

if "%BUILDTYPE%" == "Workstation" (
    echo VersionString: !workstation[%version%]!
) else (
    echo VersionString: !serveros[%version%]!
)
