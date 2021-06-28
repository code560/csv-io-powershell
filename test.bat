@echo off
setlocal

call :fnPS >> log.txt

endlocal


REM -------
:fnPS
setlocal

set CMD=powershell.exe -NoLogo -NonInteractive -C
set PS="Write-Host 'Hello World';"
call %CMD% %PS%

endlocal
exit /b %ERRORLEVEL%
