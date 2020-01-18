#!/bin/bash
db_nm="mysite"
us_nm="ilias"
pass="1337"

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
service mysql start

mkdir /var/www/html/mysite
mkdir /var/www/html/phpmyadmin

mv ./tmp/mysite /etc/nginx/sites-available/
mv ./tmp/default /etc/nginx/sites-enabled/
mv ./tmp/index.nginx-debian.html /var/www/html/

ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/

tar xzf /tmp/latest.tar.gz --strip-components=1 -C /var/www/html/mysite
tar xzf /tmp/phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

sed -i 's/database_name_here/'$db_nm'/g' /var/www/html/mysite/wp-config-sample.php
sed -i 's/username_here/'$us_nm'/g' /var/www/html/mysite/wp-config-sample.php
sed -i 's/password_here/'$pass'/g' /var/www/html/mysite/wp-config-sample.php

mysql -u root -p'root' < /var/www/html/phpmyadmin/sql/create_tables.sql

printf "create database $db_nm; create user $us_nm@localhost identified by '$pass'; grant all privileges on $db_nm.* to $us_nm@localhost; grant all privileges on phpmyadmin.* to $us_nm@localhost; flush privileges;" | mysql -u root -p'root'

chown -R www-data:www-data /var/www/html/mysite
chown -R www-data:www-data /var/www/html/phpmyadmin

bash /tmp/generator.bash
