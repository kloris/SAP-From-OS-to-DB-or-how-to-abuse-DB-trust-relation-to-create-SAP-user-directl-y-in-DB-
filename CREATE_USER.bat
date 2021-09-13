@echo off

set LD_LIBRARY_PATH=..\rfcsdk\lib

cls
echo.
echo This script creates a user in the system specified
echo FIX TO MAKE IT WORK FOR JAVA AS WELL
echo ATTENTION: CODVN MIGHT NEED TO BE SET TO OLDER OR NEWER HASH TYPE DEPENDING ON SYSTEM
echo ATTENTION: FOR ORACLE YOU MIGHT NEED TO CHANGE THE SCHEMA TO SAP-SID- ON OLDER SYTEMS
echo username is: GO_IN
echo password is: andinyougo
echo.
echo Using SAProuter: use for hostname "/H/<SAProuter-host>/H/<SAP host>"
echo.
set /p host= Gateway hostname:
set /p port= Gateway port:
set /p cli= Client:
set /p sid= SID (Lower case):
set "dbhost=localhost"
set /p dbhost= Database hostname (If DB runs on other host as GW Just press ENTER to use the default, this is LOCALHOST):
set /p db= DB type (1=MSSQL, 2=MAXDB, 3=HanaDB, 4=Oracle):
set /p stack= Stack type: (1=ABAP, 2=JAVA):
echo.


:: ##################################################################################################################################################
:: GENERAL PART

:: SET FILES TO DEFAULT
del test.pl
copy system.pl test.pl

:: Set the to be used PORT in the file test.pl
cd /d %~dp0
if exist testCleaned.pl del testCleaned.pl
Set "OldString=YYYY"
Set "NewString=%port%"
set file="test.pl"
for %%F in (%file%) do set outFile="%%~nFCleaned%%~xF"

(
  for /f "skip=2 delims=" %%a in ('find /n /v "" %file%') do (
    set "ln=%%a"
    setlocal enableDelayedExpansion
    set "ln=!ln:*]=!"
    if defined ln set "ln=!ln:%OldString%=%NewString%!"
    echo(!ln!
    endlocal
  )
)>%outFile%

:: Initialize temp helperfile
del test.pl
rename testCleaned.pl test.pl

:: Set the to be used HOSTNAME in the file test.pl
cd /d %~dp0
if exist testCleaned.pl del testCleaned.pl
Set "OldString2=XXXXXXXXXX"
Set "NewString2=%host%"
set file="test.pl"
for %%F in (%file%) do set outFile="%%~nFCleaned%%~xF"

(
  for /f "skip=2 delims=" %%a in ('find /n /v "" %file%') do (
    set "ln=%%a"
    setlocal enableDelayedExpansion
    set "ln=!ln:*]=!"
    if defined ln set "ln=!ln:%OldString2%=%NewString2%!"
    echo(!ln!
    endlocal
  )
)>%outFile%
del test.pl
rename testCleaned.pl test.pl


:: ###################CHOOSE DB
if %db% == 1 (
    goto Mssql
	)
if %db% == 2 (
	goto Maxdb
	)
if %db% == 3 (
	goto Hanadb
	)
if %db% == 4 (
	goto Oracle
	)
echo Wrong DB type chosen
exit /B


:: ##################################################################################################################################################
:: MSSQL PART
:Mssql

:: ###################CHOOSE STACK
if %stack% == 1 (
    goto Abap
	)
if %stack% == 2 (
    goto Java
	)
echo Wrong stack type chosen
exit /B

:: #######BEGIN OF ABAP PART ##########
:Abap

:: Translate SID to uppercase FOR SQL
set sid2=%sid%
    IF [%sid2%]==[] GOTO:EOF
    SET sid2=%sid2:a=A%
    SET sid2=%sid2:b=B%
    SET sid2=%sid2:c=C%
    SET sid2=%sid2:d=D%
    SET sid2=%sid2:e=E%
    SET sid2=%sid2:f=F%
    SET sid2=%sid2:g=G%
    SET sid2=%sid2:h=H%
    SET sid2=%sid2:i=I%
    SET sid2=%sid2:j=J%
    SET sid2=%sid2:k=K%
    SET sid2=%sid2:l=L%
    SET sid2=%sid2:m=M%
    SET sid2=%sid2:n=N%
    SET sid2=%sid2:o=O%
    SET sid2=%sid2:p=P%
    SET sid2=%sid2:q=Q%
    SET sid2=%sid2:r=R%
    SET sid2=%sid2:s=S%
    SET sid2=%sid2:t=T%
    SET sid2=%sid2:u=U%
    SET sid2=%sid2:v=V%
    SET sid2=%sid2:w=W%
    SET sid2=%sid2:x=X%
    SET sid2=%sid2:y=Y%
    SET sid2=%sid2:z=Z%

:: ADD THE "CREATE A USER" PART TO THE REMOTE SQL SCRIPT (This script is placed by default in the WORKdir)
..\bin\perl test.pl "echo use %sid2% > a.sql"
..\bin\perl test.pl "echo go >> a.sql"
..\bin\perl test.pl "echo INSERT INTO %sid%.USR02 (MANDT,BNAME,USTYP,CODVN) VALUES ('%cli%','GO_IN','S','G') >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: ADD THE "UPDATE THE BCODE\PASSCODE" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo UPDATE %sid%.USR02 set BCODE=0xC76AB3A59599FE3A where MANDT=%cli% and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"
..\bin\perl test.pl "echo UPDATE %sid%.USR02 set PASSCODE=0xCF017A9A4F1F53ED69CEDC773072B1B24A063A63 where MANDT=%cli% and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: ADD THE "GIVE IT REFUSER DDIC (Which means SAP_ALL)" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo INSERT INTO %sid%.USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC') >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: EXECUTE THE SCRIPT
..\bin\perl test.pl "sqlcmd -S %dbhost% -i a.sql"

goto End
:: #######END OF ABAP PART ##########

:: #######BEGIN OF JAVA PART ##########
:Java

:: Translate SID to uppercase FOR SQL
set sid2=%sid%
    IF [%sid2%]==[] GOTO:EOF
    SET sid2=%sid2:a=A%
    SET sid2=%sid2:b=B%
    SET sid2=%sid2:c=C%
    SET sid2=%sid2:d=D%
    SET sid2=%sid2:e=E%
    SET sid2=%sid2:f=F%
    SET sid2=%sid2:g=G%
    SET sid2=%sid2:h=H%
    SET sid2=%sid2:i=I%
    SET sid2=%sid2:j=J%
    SET sid2=%sid2:k=K%
    SET sid2=%sid2:l=L%
    SET sid2=%sid2:m=M%
    SET sid2=%sid2:n=N%
    SET sid2=%sid2:o=O%
    SET sid2=%sid2:p=P%
    SET sid2=%sid2:q=Q%
    SET sid2=%sid2:r=R%
    SET sid2=%sid2:s=S%
    SET sid2=%sid2:t=T%
    SET sid2=%sid2:u=U%
    SET sid2=%sid2:v=V%
    SET sid2=%sid2:w=W%
    SET sid2=%sid2:x=X%
    SET sid2=%sid2:y=Y%
    SET sid2=%sid2:z=Z%

:: ADD THE "CREATE A USER" PART TO THE REMOTE SQL SCRIPT (This script is placed by default in the WORKdir)
..\bin\perl test.pl "echo use %sid2% > a.sql"
..\bin\perl test.pl "echo go >> a.sql"
..\bin\perl test.pl "echo INSERT INTO %sid%.UME_STRINGS (MANDT,BNAME,USTYP,CODVN) VALUES ('%cli%','GO_IN','S','G') >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: ADD THE "UPDATE THE BCODE\PASSCODE" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo UPDATE %sid%.UME_STRINGS set BCODE=0xC76AB3A59599FE3A where MANDT=%cli% and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"
..\bin\perl test.pl "echo UPDATE %sid%.UME_STRINGS set PASSCODE=0xCF017A9A4F1F53ED69CEDC773072B1B24A063A63 where MANDT=%cli% and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: ADD THE "GIVE IT REFUSER DDIC (Which means SAP_ALL)" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo INSERT INTO %sid%.USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC') >> a.sql"
..\bin\perl test.pl "echo go >> a.sql"

:: EXECUTE THE SCRIPT
..\bin\perl test.pl "sqlcmd -S %dbhost% -i a.sql"

goto End
:: #######END OF JAVA PART ##########

:: ##################################################################################################################################################
:: MAXDB PART
:Maxdb

..\bin\perl test.pl "sqlcli -U DEFAULT INSERT INTO USR02 (MANDT,BNAME,BCODE,USTYP,CODVN) VALUES ('%cli%','GO_IN','C76AB3A59599FE3A','S','G')"
..\bin\perl test.pl "sqlcli -U DEFAULT UPDATE USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' where BNAME='GO_IN' and mandt='%cli%'"
..\bin\perl test.pl "sqlcli -U DEFAULT INSERT INTO USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC')"

goto End

:: ##################################################################################################################################################
:: HANA DB PART
:Hanadb

:: ADD THE "CREATE A USER" PART TO THE REMOTE SQL SCRIPT (This script is placed by default in the WORKdir)
..\bin\perl test.pl "echo INSERT INTO USR02 (MANDT,BNAME,USTYP,CODVN) VALUES ('%cli%','GO_IN','S','G') > a.sql"
..\bin\perl test.pl "echo ; >> a.sql"

:: ADD THE "UPDATE THE BCODE\PASSCODE" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo UPDATE USR02 set BCODE='C76AB3A59599FE3A' where MANDT='%cli%' and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo ; >> a.sql"
..\bin\perl test.pl "echo UPDATE USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' where MANDT='%cli%' and BNAME='GO_IN' >> a.sql"
..\bin\perl test.pl "echo ; >> a.sql"

:: ADD THE "GIVE IT REFUSER DDIC (Which means SAP_ALL)" PART TO THE REMOTE SQL SCRIPT
..\bin\perl test.pl "echo INSERT INTO USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC') >> a.sql"
..\bin\perl test.pl "echo ; >> a.sql"

:: EXECUTE THE SCRIPT
..\bin\perl test.pl "hdbsql -n %dbhost% -i 00 -U DEFAULT -o output.txt -I a.sql"


goto End
:: ##################################################################################################################################################
:: ORACLE PART
:Oracle

:: CREATE THE SQL SCRIPT

..\bin\perl test.pl "echo connect / as sysdba; > a.sql"
..\bin\perl test.pl "echo INSERT INTO SAPSR3.USR02 (MANDT,BNAME,BCODE,USTYP,CODVN) >> a.sql"
..\bin\perl test.pl "echo VALUES ('%cli%','GO_IN','C76AB3A59599FE3A','S','G'); >> a.sql"
..\bin\perl test.pl "echo UPDATE SAPSR3.USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' >> a.sql"
..\bin\perl test.pl "echo where BNAME='GO_IN' and mandt='%cli%'; >> a.sql"
..\bin\perl test.pl "echo INSERT INTO SAPSR3.USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC'); >> a.sql"

:: EXECUTE THE SCRIPT
..\bin\perl test.pl "sqlplus -S /NOLOG @a.sql"

goto End

:: ##################################################################################################################################################:: Final PART
:End
:: DELETE TEMP FILES
del test.pl

echo FOR ABAP: You can now login with username "GO_IN" and password "andinyougo" in the specified client and system
echo FOR JAVA: You can now login with username "GO_IN" and password "Andinyoug0" (mind the zero) in the specified system