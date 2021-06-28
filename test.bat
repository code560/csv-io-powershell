@echo off
setlocal
pushd %~dp0

@REM set .ps="Write-Host 'Hello World';"

set .ps="$csv=Import-Csv -Encoding Default foo.csv; $csv | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path bar.csv;"
call :fnPS %.ps% > log.txt 2>&1

popd
endlocal


REM -------
:fnPS
setlocal

set Cmd=powershell.exe -NoLogo -NonInteractive -C
set Script="%~1"
call %Cmd% %Script%

endlocal
exit /b %ERRORLEVEL%
