@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot:module=deploy%\nginx.conf

set xroot=%mroot:~0,-13%
set xnssm=%xroot%\runtime\nssm.exe

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
  set scName=WeBox-Nginx
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: Nginx�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װNginx����...
  %xnssm% install %scName% %mroot%\nginx.exe
  %xnssm% set %scName% DisplayName "Webox Nginx Server" >nul
  %xnssm% set %scName% AppParameters -p %mroot% -c %mconf% >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��Nginx����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������Nginx����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣNginx����...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo ��������Nginx����...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��Nginx����...
  ping 127.0.0.1 -n 5 >nul
  tasklist | findstr nginx.exe >nul
  if %errorlevel% neq 0 (
    echo ����: Nginx����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  call %mroot%\nginx.exe -p %mroot% -c %mconf% -t
  goto :EOF
