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

@echo. > %LOG%
@REM set .ps="Write-Host 'Hello World';"

REM ---
REM CSVを読んで出力
@REM set .ps="$csv=Import-Csv -Encoding Default foo.csv; $csv | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path bar.csv;"

REM ★
@REM set .ps="Import-Csv -Encoding Default %IN_FILE% | Export-Csv -NoTypeInformation -Delimiter ',' -Encoding Default -Path %TMP_FILE%1;"
@REM call :fnPS %.ps% >> %LOG% 2>&1

REM ---
REM CSVのダブルクォートを何も考えず除去する（後にうまく行かないクソ設計）
REM ★
@REM set .ps="Get-Content %TMP_FILE%1 | foreach {$_ -replace '""', ''} | Out-File -Encoding Default -FilePath %TMP_FILE%2;"
@REM call :fnPS %.ps% >> %LOG% 2>&1

REM ---
REM CSVを1行づつファイル出力（ヘッダーは共通/CSVモジュールを使わないバージョン）
@REM set .ps="$i=0; Get-Content %TMP_FILE%2 -ReadCount 1 | foreach {$_ | Out-File -Encoding Default -FilePath %OUT_FILE%_$i.csv; $i++;}"

@REM set .ps="$i=0; $h=(Get-Content %TMP_FILE%2)[0]; Get-Content %TMP_FILE%2 -ReadCount 1 | select -skip 1 | foreach {Out-File -InputObject $h -Encoding Default -FilePath %OUT_FILE%_$i.csv; $_ | Out-File -Encoding Default -FilePath %OUT_FILE%_$i.csv -Append; $i++;}"

@REM set .ps="$h=(Get-Content %TMP_FILE%2)[0]; Get-Content %TMP_FILE%2 -ReadCount 1 | select -skip 1 | foreach {$one=$_.Split(',')[0]; Write-Host one: $one; $o='%OUT_DIR%\'+$one+'_%OUT_FILE%.csv'; Out-File -InputObject $h -Encoding Default -FilePath $o; $_ | Out-File -Encoding Default -FilePath $o -Append;}"

REM ★
set .ps="$h=(Get-Content %IN_FILE%)[0]; Get-Content %IN_FILE% -ReadCount 1 | select -skip 1 | foreach {$one=$_.Split(',')[0]; $o='%OUT_DIR%\{0}_%OUT_FILE%.csv' -f $one; Out-File -InputObject $h -Encoding Default -FilePath $o; $_ | Out-File -Encoding Default -FilePath $o -Append;}"
call :fnPS %.ps% >> %LOG% 2>&1

REM ---
REM CSVを1行づつファイル出力（ヘッダーは共通/CSVモジュールを使うバージョン）
@REM set .ps="Import-Csv -Encoding Default %IN_FILE% | foreach {Write-Host one: $($_.ひとつめ);}"

@REM set .ps="$h=(Get-Content %IN_FILE% -Encoding Default)[0]; $csv=Import-Csv %IN_FILE% -Encoding Default | foreach {Write-Host one: $_.ひとつめ; $o='%OUT_DIR%\{0}_%OUT_FILE%.csv' -f $_.ひとつめ; Out-File -InputObject $h -FilePath $o ?-Encoding Default; Export-Csv -InputObject $_ -NoTypeInformation -Path $o -Encoding Default}"

REM ★
@REM set .ps="Import-Csv %IN_FILE% -Encoding Default | foreach {$o='%OUT_DIR%\{0}_%OUT_FILE%.csv' -f $_.ひとつめ; Export-Csv -InputObject $_ -NoTypeInformation -Path $o -Encoding Default}"

@REM set .ps="Import-Csv %IN_FILE% -Encoding Default | foreach {$f='%OUT_DIR%\{0}_%OUT_FILE%' -f $_.ひとつめ; $t='{0}.tmp' -f $f; $o='{0}.csv' -f $f; Export-Csv -InputObject $_ -NoTypeInformation -Path $t -Encoding Default; Get-Content $t | foreach {$_ -replace '""', ''} | Out-File -FilePath $o -Encoding Default}"

@REM call :fnPS %.ps% >> %LOG% 2>&1


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
