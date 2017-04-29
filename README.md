# todo-assignment
面談の課題・TODOアプリ

## コマンド
### Docker起動
```
open /Applications/Docker.app
```
### 移動
```
cd ~/todo-assignment/server/
```
### 起動
```
docker-compose up -d
```
### 停止
```
docker-compose down
```
### Webサーバ実行
```
docker exec -it srv-web /bin/bash
```
### DBリセット & マイグレーション
```
docker exec -it srv-db /bin/bash
mysql -u user -ptest123
use testdb
drop database testdb;
create database testdb;
exit;
exit

docker exec -it srv-web /bin/bash
cd /var/www/html
php yii migrate

exit
```
### 全リセット
```
docker-compose stop
docker-compose rm -f
docker system prune -f
docker rmi $(docker images -q -a) -f
```
### ngrok開始
```
ngrok http 192.168.99.100:80
```

##初期設定
### yii2
```
cd ~/todo-assignment/server/
composer self-update
composer global require "fxp/composer-asset-plugin:~1.2.0"
composer create-project --prefer-dist yiisoft/yii2-app-basic src
```
