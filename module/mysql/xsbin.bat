@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set xroot=%mroot:~0,-13%

set mconf=%mroot:module=deploy%\my.ini

call :app_runtime


::�ⲿ����ģʽ
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" (
  call :%1
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
    echo. && echo ����: �����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װMySQL����...
  %mroot%\bin\mysqld.exe --install %scName% --defaults-file="%mconf%"
  sc description %scName% "Webox MySQL Server" >nul
  call :app_start
  goto :EOF

:app_remove
  echo. && echo ����ж��MySQL����...
  net stop %scName% >nul 2>nul
  sc delete %scName% >nul 2>nul
  goto :EOF

:app_start
  echo. && echo ��������MySQL����...
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣMySQL����...
  net stop %scName% >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������MySQL����...
  net stop %scName% >nul 2>nul
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��MySQL����...
  ping 127.0.0.1 -n 1 >nul
  tasklist|find /i "mysqld.exe" >nul
  if %errorlevel% neq 0 (
    echo ����: MySQL����ʧ��
  )
  goto :EOF

:app_program
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF
