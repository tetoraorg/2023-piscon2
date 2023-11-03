#!/bin/bash

set -aux

sudo ln -sf ~/webapp/s1/isu /usr/local/bin
sudo cp ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp ./etc/nginx/isucondition.conf /etc/nginx/sites-available/isucondition.conf
sudo cp ./etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
sudo cp ./env.sh ../../env.sh

export PPROTEIN_GIT_REPOSITORY=""
export GOROOT=""
export GOPROXY=https://proxy.golang.org,direct
cd ~/webapp/go && go build -o isucondition

# log
sudo chmod +r /var/log/mysql
sudo rm -rf /var/log/mysql/mysql-slow.log /var/log/nginx/access.log
sudo touch /var/log/mysql/mysql-slow.log /var/log/nginx/access.log
sudo chmod +r /var/log/mysql/mysql-slow.log /var/log/nginx/access.log /var/log/nginx/access.log
sudo touch /var/log/mysql/mysql-slow.log /var/log/nginx/access.log
sudo chmod +r /var/log/mysql/mysql-slow.log /var/log/nginx/access.log
sudo chown mysql:mysql /var/log/mysql
sudo chown mysql:mysql /var/log/mysql/mysql-slow.log


sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
sudo systemctl restart isucondition.go.service

sudo mysql -uisucon -pisucon -e 'SET GLOBAL long_query_time = 0; SET GLOBAL slow_query_log = ON; SET GLOBAL slow_query_log_file = "/var/log/mysql/mysql-slow.log";'
