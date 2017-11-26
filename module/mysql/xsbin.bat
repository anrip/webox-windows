@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot:module=deploy%\my.ini

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

title Webox.xServer �������̨

echo.
echo �ݲ�֧�ֶ�������̨ģʽ...
pause >nul && exit


::ģ������׼�ӿ�
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:app_runtime
  set scName=Webox-MySQL
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: MySQL�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װMySQL����...
  %xnssm% install %scName% %mroot%\bin\mysqld.exe
  %xnssm% set %scName% DisplayName "Webox MySQL Server"
  %xnssm% set %scName% AppParameters --defaults-file=%mconf%
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��MySQL����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������MySQL����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣMySQL����...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo ��������MySQL����...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��MySQL����...
  ping 127.0.0.1 -n 1 >nul
  tasklist | findstr mysqld.exe >nul
  if %errorlevel% neq 0 (
    echo ����: MySQL����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF
