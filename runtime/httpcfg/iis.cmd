@echo off

cd /d %~dp0

echo. && echo ȡ��IIS���� 0.0.0.0 
httpcfg delete iplisten -i 0.0.0.0

echo. && echo �趨IIS���� 127.1.1.1
httpcfg set iplisten -i 127.1.1.1

echo. && echo ��������IIS����
net stop http /y
net start w3svc

echo. && echo �鿴TCP�˿�״̬
netstat -a -n -p tcp

ping 127.1 -n 10 > nul
