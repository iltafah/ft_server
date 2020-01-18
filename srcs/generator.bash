#!/bin/bash
randomBlowfishSecret=`openssl rand -base64 32`;
sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" var/www/html/phpmyadmin/config.sample.inc.php > var/www/html/phpmyadmin/config.inc.php


#####
cat var/www/html/mysite/wp-config-sample.php > var/www/html/mysite/wp-config.php
sed -i '48 a put me here' var/www/html/mysite/wp-config.php

i=1
while ((i <= 8))
do
	sed -i '50d' var/www/html/mysite/wp-config.php
	((i++))
done

SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put me here'
printf '%s\n' ",s/$STRING//g" a "$SALT" . w | ed -s var/www/html/mysite/wp-config.php

sed -i '49d' var/www/html/mysite/wp-config.php
