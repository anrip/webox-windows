<?php

define('TIME', time());
define('ROOT', dirname(__DIR__));

define('WB_DIR', str_replace('\\', '/', ROOT));
define('WB_IPN', gethostbyname($_SERVER['SERVER_NAME']));

define('WB_CFG', WB_DIR.'/config');
define('WB_ETC', WB_DIR.'/deploy');
define('WB_MOD', WB_DIR.'/module');

define('WB_DAT', WB_DIR.'/storage');
define('WB_WEB', WB_DIR.'/webroot');

//////////////////////////////////////reConfig//////////

echo "���������ļ�...\n\n";

move_config(WB_ETC, WB_DAT);

echo "�ؽ������ļ�...\n";

$module = array();
foreach(glob(WB_CFG.'/*.php') as $php) {
    $order = $php; $service = ''; include($php);
    $module[$order] = basename($php, '.php').' '.$service;
}

ksort($module);
$module = implode(PHP_EOL, $module);
file_put_contents(WB_ETC.'/module.ini', $module);

//////////////////////////////////////Functions//////////

// ���������ļ�
function move_config($src, $dst) {
    $src = str_replace('/', '\\', $src);
    $dst = str_replace('/', '\\', $dst);
    if(is_dir($src)) {
        exec("move /y {$src} {$dst}\deploy-".TIME);
    }
}

// �ؽ������ļ�
function build_config($src, $dst, $rep = array()) {
    if(is_file($src)) {//�ļ�
        $content = file_get_contents($src);
        return file_put_contents($dst, strtr($content, $rep));
    }
    if(is_dir($src)) {//Ŀ¼
        aw_copy($src, $dst);
        foreach(aw_glob($dst) as $f) {
            build_config($f, $f, $rep);
        }
    }
}

// PHP�����ļ��ϲ�����
function merge_php_ini($path) {
    $string = '';
    $target = $path.'/php.ini';
    foreach(glob($path.'/php*.ini') as $ini) {
        $string .= file_get_contents($ini)."\r\n";
        unlink($ini);
    }
    $string = preg_replace('/[\r\n]+;.*/', '', $string);
    file_put_contents($target, $string);
    return $target;
}

// �ݹ鸴��Ŀ¼
function aw_copy($src, $dst) {
    if($src == $dst || !is_dir($src)) {
        return false;
    }
    $src = str_replace('/', '\\', $src);
    $dst = str_replace('/', '\\', $dst);
    exec("xcopy {$src} {$dst} /e /i /r /q", $a, $r);
    return !$r;
}

// �ݹ��ȡ�ļ�
function aw_glob($path, $mark = '*', $full = false) {
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
