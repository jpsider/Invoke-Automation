@echo off

REM set the executable and username
if exist "C:\wamp\bin\mysql\mysql5.6.17\bin\mysql.exe" (
	set MYSQL_EXE="C:\wamp\bin\mysql\mysql5.6.17\bin\mysql.exe"
)
if exist "C:\wamp\bin\mysql\mysql5.7.11\bin\mysql.exe" (
	set MYSQL_EXE="C:\wamp\bin\mysql\mysql5.7.11\bin\mysql.exe"
)

set DB_USER=root

goto :MAIN

:CreateDatabase
call %MYSQL_EXE% -u %DB_USER% < "Database_Deployment.sql"
goto :EOF

:InsertDemoData
rem call %MYSQL_EXE% -u %DB_USER% < "Insert_Example_Data.sql"
goto :EOF

:MAIN
call :CreateDatabase
call :InsertDemoData
call :exit

:exit
pause
exit 0


