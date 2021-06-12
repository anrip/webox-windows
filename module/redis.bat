@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set xroot=%~dp0
set xroot=%xroot:~0,-7%
set xnssm=%xroot%\runtime\nssm.exe

set mroot=%xroot%\module\%~n0
set mconf=%xroot%\config\%~n0\redis.conf

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
  set scName=WeBox-Redis
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: Redis�����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װRedis����...
  %xnssm% install %scName% %mroot%\redis-server.exe
  %xnssm% set %scName% DisplayName "WeBox Redis Server" >nul
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
