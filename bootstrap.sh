#!/usr/bin/env bash

printf "\n--- Running apt Update & Upgrade ---\n"
# update / upgrade
sudo apt-get -y update
sudo apt-get -y upgrade

printf "\n--- Installing Apache & PHP ---\n"
# install apache, php7, php-curl & php-mcrypt
sudo apt-get install -y apache2 php libapache2-mod-php php-curl php-mcrypt php-bz2 php-zip php-intl php-imagick php-apcu php-redis

printf "\n--- Installing MySQL ---\n"
# install mysql and give password to installer
PASSWORD='12345678' # Use single quotes instead of double quotes to make it work with special-character passwords
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get install -y mysql-server php-mysql

printf "\n--- Configuring Apache & MySQL ---\n"
# config mysql for external access
printf "\n[mysqld]\nbind-address = 0.0.0.0" >> /etc/mysql/mysql.cnf
MYSQL_PWD=$PASSWORD mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;"
MYSQL_PWD=$PASSWORD mysql -u root -e "FLUSH PRIVILEGES;"

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt install -y phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/vagrant/public"
    <Directory "/vagrant/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf
echo "<?php phpinfo();" > /vagrant/public/index.php

# enable mod_*
sudo a2enmod rewrite

printf "\n--- Restarting apache & mysql ---\n"
sudo service apache2 restart
sudo service mysql restart

printf "\n--- Installing remaining apt packages ---\n"
sudo apt-get install -y git npm

printf "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php >> /dev/null 2>&1
mv composer.phar /usr/local/bin/composer

# All Done
printf "\n--- Done: http://192.168.33.10 ---\n"