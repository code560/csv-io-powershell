@echo off
setlocal
pushd %~dp0

set LOG=log.txt

set IN_FILE=foo.csv
set TMP_FILE=tmp.dat
set OUT_DIR=.\out
set OUT_FILE=bar

del TMP_FILE >nul 2>&1
del OUT_FILE >nul 2>&1
md out >nul 2>&1

@REM set .ps="Write-Host 'Hello World';"

set .ps="Import-Csv -Encoding Default %IN_FILE% | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path %TMP_FILE%1;"
@REM set .ps="$csv=Import-Csv -Encoding Default foo.csv; $csv | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path bar.csv;"
call :fnPS %.ps% > %LOG% 2>&1


set .ps="Get-Content %TMP_FILE%1| foreach {$_ -replace '""', ''} | Out-File -Encoding Default -FilePath %TMP_FILE%2;"
call :fnPS %.ps% >> %LOG% 2>&1


@REM set .ps="$i=0; Get-Content %TMP_FILE%2 -ReadCount 1 | foreach {$_ | Out-File -Encoding Default -FilePath %OUT_FILE%_$i.csv; $i++;}"

@REM set .ps="$i=0; $h=(Get-Content %TMP_FILE%2)[0]; Get-Content %TMP_FILE%2 -ReadCount 1 | select -skip 1 | foreach {Out-File -InputObject $h -Encoding Default -FilePath %OUT_FILE%_$i.csv; $_ | Out-File -Encoding Default -FilePath %OUT_FILE%_$i.csv -Append; $i++;}"

set .ps="$h=(Get-Content %TMP_FILE%2)[0]; Get-Content %TMP_FILE%2 -ReadCount 1 | select -skip 1 | foreach {$one=$_.Split(',')[0]; Write-Host one: $one; $o='%OUT_DIR%\'+$one+'_%OUT_FILE%.csv'; Out-File -InputObject $h -Encoding Default -FilePath $o; $_ | Out-File -Encoding Default -FilePath $o -Append;}"

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
