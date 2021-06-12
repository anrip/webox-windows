@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set xroot=%~dp0
set xroot=%xroot:~0,-7%
set xnssm=%xroot%\runtime\nssm.exe

set mroot=%xroot%\module\%~n0
set mconf=%xroot%\config\%~n0\my.ini

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
  set scName=WeBox-MySQL
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: MySQL�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װMySQL����...
  %xnssm% install %scName% %mroot%\bin\mysqld.exe
  %xnssm% set %scName% DisplayName "WeBox MySQL Server" >nul
  %xnssm% set %scName% AppParameters --defaults-file=%mconf% >nul
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
