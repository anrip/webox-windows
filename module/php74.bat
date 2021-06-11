@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set xroot=%~dp0
set xroot=%xroot:~0,-7%
set xnssm=%xroot%\runtime\nssm.exe

set mroot=%xroot%\module\%~n0
set mconf=%xroot%\deploy\%~n0\php.ini
set nconf=%xroot%\deploy\%~n0\fpm.ini

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
  set scName=WeBox-PHP74
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: PHP74�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װPHP74����...
  %xnssm% install %scName% %mroot%\fpm74.exe
  %xnssm% set %scName% DisplayName "WeBox PHP74 Server" >nul
  for /f "eol=; tokens=1,2,3,4" %%h in (%nconf%) do (
    %xnssm% set %scName% AppParameters \"%mroot%\php74.exe -c %mconf%\" %%h %%i >nul
    break
  )
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��PHP74����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������PHP74����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣPHP74����...
  %xnssm% stop %scName%
  taskkill /T /F /IM php5* >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������PHP74����...
  %xnssm% stop %scName%
  taskkill /T /F /IM php5* >nul 2>nul
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��PHPye����...
  ping 127.0.0.1 -n 1 >nul
  tasklist | findstr php74.exe >nul
  if %errorlevel% neq 0 (
    echo ����: PHP74����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF
