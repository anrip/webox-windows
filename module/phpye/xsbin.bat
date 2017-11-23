@echo off

::�����ڲ�����
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

setlocal

set mroot=%~dp0
set mroot=%mroot:~0,-1%
set xroot=%mroot:~0,-13%

set mconf=%mroot:module=deploy%\phpye.ini

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
  set xsbin=%mroot%\xspye.exe
  set xsfpm=%mroot%\bin\xsfpm.exe
  set scName=Webox-PHPye
  set scPath=%mroot%
  set scExec=%~nx0
  set scPara=app_program
  goto :EOF

:app_create
  echo. && echo ���ڰ�װPHPye����...
  sc create %scName% binPath= "%xsbin%" start= auto >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "AppDirectory" /d "%scPath%" >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "Application" /d "%scExec%" >nul
  reg add "HKLM\SYSTEM\CurrentControlSet\Services\%scName%\Parameters" /v "AppParameters" /d "%scPara%" >nul
  sc description %scName% "Webox PHPye Server" >nul
  call :app_start
  goto :EOF

:app_remove
  call :app_stop
  echo. && echo ����ж��PHPye����...
  sc delete %scName% >nul 2>nul
  goto :EOF

:app_start
  echo. && echo ��������PHPye����...
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_stop
  echo. && echo ����ֹͣPHPye����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM xsfpm.exe >nul 2>nul
  taskkill /T /F /IM php5* >nul 2>nul
  goto :EOF

:app_reboot
  echo. && echo ��������PHPye����...
  net stop %scName% >nul 2>nul
  taskkill /T /F /IM xsfpm.exe >nul 2>nul
  taskkill /T /F /IM php5* >nul 2>nul
  net start %scName% >nul 2>nul
  call :app_progress
  goto :EOF

:app_progress
  echo. && echo ���ڼ��PHPye����...
  ping 127.0.0.1 -n 1 >nul
  tasklist|find /i "xsfpm.exe" >nul
  if %errorlevel% neq 0 (
    echo ����: PHPye����ʧ��
  )
  goto :EOF

:app_program
  call :check_network
  for /f "eol=; tokens=1,2,3,4" %%h in (%mconf%) do (
    start %xsfpm% "%xroot%\module\%%i\%%i.exe -c %xroot%\deploy\%%i" -i 127.0.0.1 -p %%j -n %%k
  )
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
