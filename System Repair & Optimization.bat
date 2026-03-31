@echo off
chcp 65001 >nul
title Otimizador de Sistema - Windows
color 0A

:: Verificar admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Solicitando permissões de administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0' -Verb RunAs"
    exit
)

:menu
cls
echo.
echo ==========================================================
echo                 OTIMIZADOR AVANÇADO DO WINDOWS
echo ==========================================================
echo.
echo [1] Verificar Arquivos do Sistema (SFC)
echo [2] Reparar Imagem do Windows (DISM)
echo [3] Verificar Disco (CHKDSK)
echo [4] Limpar Arquivos Temporários
echo [5] Limpar Cache DNS
echo [6] Verificar Drivers
echo [7] Executar Manutenção Completa
echo [0] Sair
echo.
echo ==========================================================
echo.
set /p opcao=Digite uma opção: 

if "%opcao%"=="1" goto sfc
if "%opcao%"=="2" goto dism
if "%opcao%"=="3" goto chkdsk
if "%opcao%"=="4" goto temp
if "%opcao%"=="5" goto dns
if "%opcao%"=="6" goto drivers
if "%opcao%"=="7" goto tudo
if "%opcao%"=="0" exit

echo.
echo Opção inválida!
pause
goto menu

:sfc
cls
echo ==========================================================
echo           VERIFICAÇÃO DE INTEGRIDADE DO SISTEMA
echo ==========================================================
echo.
echo Corrigindo automaticamente arquivos corrompidos...
sfc /scannow
echo.
echo ✔ Verificação concluída!
pause
goto menu

:dism
cls
echo ==========================================================
echo             REPARO DA IMAGEM DO WINDOWS
echo ==========================================================
echo.
echo Verificando a integridade da imagem do sistema...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo ✔ Reparo concluído!
pause
goto menu

:chkdsk
cls
echo ==========================================================
echo               ANÁLISE E REPARO DO DISCO
echo ==========================================================
echo.
echo Verificando erros no sistema de arquivos...
chkdsk C: /f /r
echo.
echo ✔ Verificação concluída!
pause
goto menu

:temp
cls
echo ==========================================================
echo         LIMPEZA DE ARQUIVOS TEMPORÁRIOS
echo ==========================================================
echo.
echo Removendo arquivos temporários...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo.
echo ✔ Limpeza concluída!
pause
goto menu

:dns
cls
echo ==========================================================
echo               LIMPEZA DE CACHE DE DNS
echo ==========================================================
echo.
echo Limpando registros de resolução de nomes...
ipconfig /flushdns
echo.
echo ✔ Cache DNS atualizado!
pause
goto menu

:drivers
cls
echo ==========================================================
echo               DIAGNÓSTICO DE DRIVERS
echo ==========================================================
echo.
echo Listando drivers instalados no sistema...
driverquery
echo.
echo Dispositivos com problemas detectados:
wmic path win32_pnpentity where "ConfigManagerErrorCode<>0" get Name,ConfigManagerErrorCode
echo.
echo ✔ Diagnóstico concluído!
pause
goto menu

:tudo
cls
echo ==========================================================
echo           MANUTENÇÃO COMPLETA DO SISTEMA
echo ==========================================================
echo.

echo [1/6] Verificando arquivos do sistema...
sfc /scannow

echo.
echo [2/6] Reparando imagem do sistema...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [3/6] Verificando o disco...
chkdsk C: /f /r

echo.
echo [4/6] Limpando arquivos temporários...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul

echo.
echo [5/6] Limpando cache DNS...
ipconfig /flushdns

echo.
echo [6/6] Diagnóstico de drivers...
driverquery
wmic path win32_pnpentity where "ConfigManagerErrorCode<>0" get Name,ConfigManagerErrorCode

echo.
echo ==========================================================
echo           ✔ MANUTENÇÃO FINALIZADA COM SUCESSO
echo ==========================================================
pause
goto menu