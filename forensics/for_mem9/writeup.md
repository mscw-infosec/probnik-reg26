Видим перед нами дамп памяти, первое что хочется сделать это посмотреть файлы и процессы. Сначала файлы:
```bash
vol -f dumpB.raw windows.filescan
```

После windows.filescan видим на рабочем столе пользователя `user` файл `AdminScript.bat`, сдампим его:
```bash
vol -f dumpA.raw windows.dumpfiles --virtaddr 0xaece2890
```
Читаем:
```bat
@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~2"=="X" goto _a
if "%~1"=="Y" goto _b
goto _c


:_a
for /L %%Q in (1,1,3) do (
    set /a R+=%%Q
)
goto _run


:_b
cd /d "%~dp0" >nul 2>&1
goto _run


:_c
ver >nul
goto _run


:_run
call _x1
call _x2
call _x3

timeout /t 300 /nobreak >nul

call _x4
goto _end


:_x1
set /a A=1+1
if %A%==2 goto :eof
exit /b


:_x2
for %%M in (%TIME%) do (
    rem.
)
goto :eof


:_x3
set P=%RANDOM%
if %P% LSS 0 goto _x3
goto :eof


:_x4
whoami >nul 2>&1
goto :eof


:_end
endlocal
exit /b


:vsosh{
goto :eof

:Adm1n_
if not errorlevel 1 goto :eof

:cmd_
set /a Z=42
goto :eof

:scr1pts}
exit /b
```
из некоторх строк в конце файла удобно складывается первый флаг: **vsosh{Adm1n_cmd_scr1pts}**.

Посмотрим процессы, запущенные в системе:
```bash
vol -f dumpB.raw windows.pslist
```
Видим запущенную cmd:
`7192	3372	cmd.exe	0xaa7d27c0	3	-	1	False	2026-01-04 17:09:03.000000 UTC	N/A	Disabled`
Посмотрим что в ней вводилось:
```bash
vol -f dumpB.raw windows.cmdline
```
Видим запуск notepad.exe со странным флагом:
`6564	notepad.exe	notepad.exe  --ctf 99zP/cGNsZ2X0RDa091cx8Fd0g2V7h2cvNnd`
попробуем раздекодить стрку из base64 и из перевёрнутого base64:
```bash
echo '99zP/cGNsZ2X0RDa091cx8Fd0g2V7h2cvNnd' | base64 -d 

echo '99zP/cGNsZ2X0RDa091cx8Fd0g2V7h2cvNnd' | rev | base64 -d 
```
Во втором случае получаем второй флаг: **vsosh{Wh4t_1s_th4t_fl4g???}**.

