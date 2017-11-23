@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set xroot=%mroot:~0,-13%

set mconf=%mroot:module=deploy%\nginx.conf

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
  set xsbin=%mroot%\xsngx.exe
  set scName=Webox-Nginx
  set scPath=%mroot%
  set scExec=%~nx0
  set scPara=app_program
  goto :EOF

:app_create
  echo. && echo ���ڰ�װNginx����...
  sc create %scName% binPath= "%xsbin%" start= auto >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "AppDirectory" /d "%scPath%" >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "Application" /d "%scExec%" >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "AppParameters" /d "%scPara%" >nul
  sc description %scName% "Webox Web Server" >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��Nginx����...
  sc delete %scName% >nul 2>nul
  goto :EOF

:app_start
  echo. && echo ��������Nginx����...
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣNginx����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM nginx.exe >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������Nginx����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM nginx.exe >nul 2>nul
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��Nginx����...
  ping 127.0.0.1 -n 5 >nul
  tasklist|find /i "nginx.exe" >nul
  if %errorlevel% neq 0 (
    echo ����: Nginx����ʧ��
  )
  goto :EOF

:app_configure
  goto :EOF

:app_configtest
  call %mroot%\nginx.exe -p "%mroot%" -c "%mconf%" -t
  goto :EOF

:app_program
  call :check_network
  start %mroot%\nginx.exe -p "%mroot%" -c "%mconf%"
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
