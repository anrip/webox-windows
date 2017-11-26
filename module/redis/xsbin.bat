@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set mconf=%mroot:module=deploy%\redis.conf

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
  set scName=Webox-Redis
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: Redis�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װRedis����...
  %xnssm% install %scName% %mroot%\redis-server.exe
  %xnssm% set %scName% DisplayName "Webox Redis Server" >nul
  %xnssm% set %scName% AppParameters %mconf% >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��Redis����...
  %xnssm% remove %scName% confirm
  goto :EOF

:app_start
  echo. && echo ��������Redis����...
  %xnssm% start %scName%
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣRedis����...
  %xnssm% stop %scName%
  goto :EOF

:app_reboot
  echo. && echo ��������Redis����...
  %xnssm% restart %scName%
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��Redis����...
  ping 127.0.0.1 -n 5 >nul
  tasklist | findstr redis-server.exe >nul
  if %errorlevel% neq 0 (
    echo ����: Redis����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF
