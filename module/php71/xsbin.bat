@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot:module=deploy%\php.ini

set xroot=%mroot:~0,-13%
set xnssm=%xroot%\runtime\nssm.exe
set xconf=%mroot:module=deploy%\xxfpm.ini

call :app_runtime


::�ⲿ����ģʽ
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" (
  call :app_%1
  goto :EOF
  exit
)


::��������̨ģʽ
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

title Webox.xServer �������̨

echo.
echo �ݲ�֧�ֶ�������̨ģʽ...
pause >nul && exit


::ģ������׼�ӿ�
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=Webox-PHP71
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: PHP71�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װPHP71����...
  %xnssm% install %scName% %mroot%\xxfpm\fpm71.exe
  %xnssm% set %scName% DisplayName "Webox PHP71 Server" >nul
  for /f "eol=; tokens=1,2,3,4" %%h in (%xconf%) do (
    %xnssm% set %scName% AppParameters \"%mroot%\php71.exe -c %mconf%\" -i %%h -p %%i -n %%j >nul
    break
  )
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��PHP71����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������PHP71����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣPHP71����...
  %xnssm% stop %scName%
  taskkill /T /F /IM php5* >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������PHP71����...
  %xnssm% stop %scName%
  taskkill /T /F /IM php5* >nul 2>nul
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��PHPye����...
  ping 127.0.0.1 -n 1 >nul
  tasklist | findstr php71.exe >nul
  if %errorlevel% neq 0 (
    echo ����: PHP71����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF
