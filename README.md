# Webox.xServer ʹ���ֲ�

����: HTTP + Redis + MYSQL + PHP(FCGI)

����: ����[mail@anrip.com] & ���[mod@kerring.me]

��ҳ: http://www.anrip.com

˵��: xServer��ҵ���׼�ͨ��CMDʵ�ֱ�׼����ӿڵļ��ɻ�WEB��������

����:

 - ֧��php��汾�л���ͬʱ����

 - ֧��Ϊվ�����ö���php����

### ��װ��

1.��ѹ��������̸�Ŀ¼�����������������ļ������ַ���Ŀ¼

2.�������IIS����������runtime\httpcfg\iis.cmd�޸�IIS������ַ

3.����xServer.bat��ѡ��[��װ����]������ʹ��MYSQL+Nginx+PHP�ȷ���

  Nginx Ĭ�ϼ�����ַΪ 0.0.0.0:80
  MySQL Ĭ�ϼ�����ַΪ 127.0.0.1:3306
  PHP56 Ĭ�ϼ�����ַΪ 127.0.0.1:9501
  PHP71 Ĭ�ϼ�����ַΪ 127.0.0.1:9701

### ����б�

Redis/3.2.100               https://github.com/dmajkic/redis/downloads

MySQL/5.7.19                http://www.mysql.com/downloads/mysql

Nginx/1.12.2                http://www.nginx.org/en/download.html

PHP/5.6.32
PHP/7.1.11                  http://windows.php.net/download

PHP-redis/3.1.3             http://pecl.php.net/package/redis
PHP-xdebug/2.5.5            http://pecl.php.net/package/xdebug

### ��������

���棺
  �����޸ķ��������������޸�configĿ¼�ڶ�Ӧ���ļ�

�����������ģ��
1��config\*.php��ʾ�Ѿ����õ�ģ��
2��config\*.dis��ʾ�Ѿ����õ�ģ��

һ����ν�����վ��
1.����������Ӧ����վĿ¼������ webroot\net.anrip\www

������ι���MySQL
1.ʹ�����������http://127.0.0.1/dber.php
2.������:127.0.0.1���ʻ�:root/����:��

��������л�PHP�汾
1.ȷ������δ��װ��������[ж�ط���]
2.�༭config\phpye\phpye.ini�޸Ľ��̳ز���
3.�༭Nginx����etc/suffix/*.inc���޸�Ϊ��Ӧ�˿�
3.����xServer.bat��ѡ��[�ؽ�����]����ѡ��[��������]

�ġ�����޸�WEB��Ŀ¼
1.�༭runtime\config.php���޸�[XS.WEB]��ֵ
2.����[XS.WEB]��ӦĿ¼�����ƶ�ԭWEB��[XS.WEB]Ŀ¼
3.����xServer.bat��ѡ��[�ؽ�����]����ѡ��[��������]

�塢����޸�MySQL����Ŀ¼
1.�༭runtime\config.php���޸�[XS.SQL]��ֵ
2.����[XS.SQL]��ӦĿ¼�����ƶ�ԭMySQL���ݵ�[XS.SQL]Ŀ¼
3.����xServer.bat��ѡ��[�ؽ�����]����ѡ��[��������]

### ������־

2017��11��23��
- ����PHP5�汾Ϊ5.6.32
- ����PHP7�汾Ϊ7.1.11
- ����Nginx�汾Ϊ1.12.2

2017��09��28��
- ����PHP5�汾Ϊ5.6.31

2017��09��13��
- ����PHP�汾Ϊ7.1.9
- ����MySQL�汾Ϊ5.7.19

2017��08��23��
- ����vc_redist_2013

2017��07��13��
- ����PHP�汾Ϊ7.1.7
- ����Nginx�汾Ϊ1.12.1

2017��05��27��
- ��php57����Ϊphp71
- ��ԭ�����ļ�����

2017��05��15��
- ����֧��32λ����ϵͳ
- ����PHP�汾Ϊ7.1.4
- ����Nginx�汾Ϊ1.12.0
- ����MySQL�汾Ϊ5.7.18
- ����Redis�汾Ϊ3.2.100

2017��֮ǰ
- ֧�� Windows 32bit
- ������־������32λ���ݰ�鿴

2015��֮ǰ
- ֧�� Windows XP +
- ������־������XP���ݰ�鿴
