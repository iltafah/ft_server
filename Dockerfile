From debian:buster

COPY ./srcs/ ./tmp

RUN apt update && \
	cat /tmp/packages.txt | xargs apt install -y && \
	wget -i /tmp/links.txt -P /tmp && \
	printf "1\n1\n4\n" | dpkg -i /tmp/mysql-apt-config_0.8.13-1_all.deb && \
	apt update && \
	printf "%s\n" "mysql-community-server mysql-community-server/root-pass password root" | debconf-set-selections && \
    printf "%s\n" "mysql-community-server mysql-community-server/re-root-pass password root" | debconf-set-selections && \
	apt -y install mysql-server && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -subj "/C=US/ST=New York/L=Rochester/O=localhost/OU=Development/CN=localhost" && \
	mv localhost.crt /etc/ssl/certs/localhost.crt && \
	mv localhost.key /etc/ssl/private/localhost.key && \
	bash /tmp/rest.bash

CMD bash /tmp/run.bash
