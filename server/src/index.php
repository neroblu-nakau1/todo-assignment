<?php

register_shutdown_function(
    function(){
        $e = error_get_last();
        if( $e['type'] == E_ERROR ||
            $e['type'] == E_PARSE ||
            $e['type'] == E_CORE_ERROR ||
            $e['type'] == E_COMPILE_ERROR ||
            $e['type'] == E_USER_ERROR ){

            echo "<pre>";
            echo "Error type:\t {$e['type']}\n";
            echo "Error message:\t {$e['message']}\n";
            echo "Error file:\t {$e['file']}\n";
            echo "Error line:\t {$e['line']}\n";
            echo "</pre>";
        }
    }
);

error_reporting(E_ALL);
$pdo = new PDO('mysql:host=srv-db;port=3306;dbname=testdb;charset=utf8', 'user', 'test123');
$r = $pdo->query("show tables");
var_dump($r->fetchAll());
echo ini_get('date.timezone');