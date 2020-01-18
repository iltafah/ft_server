#!/bin/bash
find /var/lib/mysql -type f -exec touch {} \;
service nginx start
service mysql start
service php7.3-fpm start

grn=$'\e[1;32m'
red=$'\e[1;31m'

while ((1))
do
	nginx=`service nginx status | grep -c not`
	php=`service php7.3-fpm status | grep -c not`
	mysql=`service mysql status | grep -c not`
	
	printf "${grn}%s\n\n" "services are running well"

	if  (( $nginx == 1 ));
	then
		printf "${red}%s\n" "nginx has stopped"
		exit
	elif (( $php == 1 ));
	then
		printf "${red}%s\n" "php7.3-fpm has stopped"
		exit
	elif (( $mysql == 1 ));
	then
		printf "${red}%s\n" "mysql has stopped"
		exit
	fi
	sleep 10
done

