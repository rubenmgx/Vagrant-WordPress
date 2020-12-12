#!/bin/bash

#Prerequisites
sudo apt update
sudo apt install -y wordpress php libapache2-mod-php mysql-server php-mysql


#Apache Configuration 
sudo echo "Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>" > /etc/apache2/sites-available/wordpress.conf

sudo a2ensite wordpress
sudo a2enmod rewrite
sudo service apache2 reload
sudo systemctl enable apache2

#BBDD Configuration ( database, user...)
sudo mysql -u root -e "CREATE DATABASE wordpress;"
sudo mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost IDENTIFIED BY 'password';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

sudo echo "<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'localhost');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>" > /etc/wordpress/config-localhost.php

sudo systemctl enable mysql

#Sending preconfigured config to WordPress (to avoid wordpress set up)
sudo mysql --user=root --password=root wordpress < /vagrant/wordpress_db/wordpress.sql
sudo rm -r /usr/share/wordpress/
sudo ln -s /vagrant/wordpress /usr/share/ 

sudo service mysql start


#Filebeat Installation/Configuration
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install filebeat
sudo filebeat modules enable  mysql apache
cp -f /vagrant/images_yml/filebeat.yml /etc/filebeat/filebeat.yml
sudo systemctl start filebeat && sudo systemctl enable filebeat