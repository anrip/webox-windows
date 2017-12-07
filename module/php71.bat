@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set xroot=%~dp0
set xroot=%xroot:~0,-7%
set xnssm=%xroot%\runtime\nssm.exe

set mroot=%xroot%\module\%~n0
set mconf=%xroot%\deploy\%~n0\php.ini
set nconf=%xroot%\deploy\%~n0\xxfpm.ini

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

title %scName% �������̨

echo.
echo �ݲ�֧�ֶ�������̨ģʽ...
pause >nul && exit


::ģ������׼�ӿ�
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=WeBox-PHP71
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: PHP71�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װPHP71����...
  %xnssm% install %scName% %mroot%\xxfpm\fpm71.exe
  %xnssm% set %scName% DisplayName "WeBox PHP71 Server" >nul
  for /f "eol=; tokens=1,2,3,4" %%h in (%nconf%) do (
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
