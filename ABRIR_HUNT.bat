@echo off
title Hunt Análise

set CHROME="C:\Program Files\Google\Chrome\Application\chrome.exe"
set EDGE="C:\Program Files\Microsoft\Edge\Application\msedge.exe"
set EDGE2="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

:: Pegar o primeiro argumento (remover aspas se tiver)
set "URL=%~1"
:: Se a URL for vazia, usar default
if "%URL%"=="" set "URL=file:///C:/HuntAnalise/hunt_analise.html"

set FLAGS=--allow-file-access-from-files --disable-web-security --user-data-dir="%TEMP%\hunt_chrome_profile"

if exist %CHROME% (
    start "" %CHROME% %FLAGS% "%URL%"
    goto :fim
)
if exist %EDGE% (
    start "" %EDGE% %FLAGS% "%URL%"
    goto :fim
)
if exist %EDGE2% (
    start "" %EDGE2% %FLAGS% "%URL%"
    goto :fim
)
echo Browser nao encontrado.
pause
:fim
