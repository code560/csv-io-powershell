@echo off
setlocal
pushd %~dp0

set LOG=log.txt

set IN_FILE=foo.csv
set TMP_FILE=tmp.dat
set OUT_FILE=bar.csv

del TMP_FILE >nul 2>&1
del OUT_FILE >nul 2>&1


@REM set .ps="Write-Host 'Hello World';"

set .ps="Import-Csv -Encoding Default %IN_FILE% | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path %TMP_FILE%;"
@REM set .ps="$csv=Import-Csv -Encoding Default foo.csv; $csv | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path bar.csv;"
call :fnPS %.ps% > %LOG% 2>&1


set .ps="Get-Content %TMP_FILE% | foreach { $_ -replace '""', '' } | Out-File -Encoding Default -FilePath %OUT_FILE%;"
call :fnPS %.ps% >> %LOG% 2>&1

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
