#!/bin/bash

sudo dnf install -y httpd

# config file
vim /etc/httpd/conf/httpd.conf
# drop in config files
vim /etc/httpd/conf.d/
# root directory for .html files
/var/www/html/ # empty by default

systemctl enable httpd
systemctl start httpd

## creating a basic web server

curl http://localhost # doesn't work

sudo su
# http logs
vim /var/log/httpd/error_log

cd /var/www/html/
vim index.html
hello and welcome to my world

chmod o+r index.html # must be readable by others
systemctl restart httpd
curl http://localhost # works

# make umask global for all users
echo 'umask 0022' | sudo tee -a /etc/profile
