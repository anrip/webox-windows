<?php

//ϵͳ��������
define('TIME', time());
define('ROOT', getcwd());
define('XS_DIR', str_replace('\\', '/', ROOT));
define('XS_IPN', gethostbyname($_SERVER['SERVER_NAME']));

//�û���������
define('XS_CFG', XS_DIR.'/config');//�����ļ���Ŀ¼
define('XS_ETC', XS_DIR.'/deploy');//�����ļ���Ŀ¼
define('XS_MOD', XS_DIR.'/module');//Ӧ��ģ���Ŀ¼
define('XS_DAT', XS_DIR.'/storage');//�����ļ���Ŀ¼
define('XS_WEB', XS_DIR.'/webroot');//վ���ļ���Ŀ¼

//////////////////////////////////////reConfig//////////

echo "���������ļ�...\n\n";

mvConfig(XS_ETC, XS_DAT);

echo "�ؽ������ļ�...\n";

$module = array();
foreach(glob(XS_CFG.'/*.php') as $php) {
    $order = $php; $service = ''; include($php);
    $module[$order] = basename($php, '.php').' '.$service;
}

ksort($module);
$module = implode(PHP_EOL, $module);
file_put_contents(XS_ETC.'/module.ini', $module);

//////////////////////////////////////Functions//////////

//���������ļ�
function mvConfig($src, $dst) {
    $src = str_replace('/', '\\', $src);
    $dst = str_replace('/', '\\', $dst);
    if(is_dir($src)) {
        exec("move /y {$src} {$dst}\deploy-".TIME);
    }
}

//�ؽ������ļ�
function reConfig($src, $dst, $rep = array()) {
    if(is_file($src)) {//�ļ�
        $content = file_get_contents($src);
        return file_put_contents($dst, strtr($content, $rep));
    }
    if(is_dir($src)) {//Ŀ¼
        aw_copy($src, $dst);
        foreach(aw_glob($dst) as $f) {
            reConfig($f, $f, $rep);
        }
    }
}

//�ݹ鸴��Ŀ¼
function aw_copy($src, $dst) {
    if($src == $dst || !is_dir($src)) {
        return false;
    }
    $src = str_replace('/', '\\', $src);
    $dst = str_replace('/', '\\', $dst);
    exec("xcopy {$src} {$dst} /e /i /r /q", $a, $r);
    return !$r;
}

//�ݹ��ȡ�ļ�
function aw_glob($path = './', $mark = '*', $full = false) {
    $files = array();
    //��ȡ��Ŀ¼�ļ�
    if($result = glob($path.$mark, GLOB_MARK|GLOB_BRACE)) {
        $result = str_replace('\\', '/', $result);
        foreach($result as $file) {
            substr($file, -1, 1) == '/' || $files[] = $file;
        }
    }
    //��ȡ��Ŀ¼�ļ�
    if($result = glob($path.'*', GLOB_MARK|GLOB_ONLYDIR)) {
        $result = str_replace('\\', '/', $result);
        foreach($result as $path) {
            $full && $files[] = $path;
            $files = array_merge($files, aw_glob($path, $mark, $full));
        }
    }
    return $files;
}

?>