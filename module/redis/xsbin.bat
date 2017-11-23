@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set xroot=%mroot:~0,-13%

set mconf=%mroot:module=deploy%\redis.conf

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
  set scName=Webox-Redis
  goto :EOF

:app_create
  if not exist "%mconf%" (
    echo. && echo ����: �����ļ�������...
    goto :EOF
  )
  echo. && echo ���ڰ�װRedis����...
  %mroot%\redis-server.exe --service-install --service-name %scName% "%mconf%"
  sc description %scName% "Webox Redis Server" >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��Redis����...
  sc delete %scName% >nul 2>nul
  goto :EOF

:app_start
  echo. && echo ��������Redis����...
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣRedis����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM redis-server.exe >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������Redis����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM redis-server.exe >nul 2>nul
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��Redis����...
  ping 127.0.0.1 -n 5 >nul
  tasklist|find /i "redis-server.exe" >nul
  if %errorlevel% neq 0 (
    echo ����: Redis����ʧ��
  )
  goto :EOF

:app_program
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  goto :EOF


::�������Խű�
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::��Ȿ�������Ƿ����
:check_network
  echo. && echo ���ڲ������绷��...
  ping 127.0.0.1 -n 2 >nul || (
    echo ����ʧ��,������������
    goto check_network
  )
  goto :EOF
