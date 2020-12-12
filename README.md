<h1>With this repository, you will have a full Wordpress installation ready to use</h1>


<h3>How vagrant works</h3>

- vagrant up wordpress  -> Will create and bring up the Virtual Machine

      After bringing up the wordpress machine, you will be immediately able to connect to wordpress. 
      
- vagrant ssh wordpress -> In case you need to connect to it.


<h3>Wordpress</h3>

- Admin   : http://localhost:8080/blog/wp-admin/ 
- Homepage: http://localhost:8080/blog/ 

<h3>What configuration_wordpress.sh does:</h3>

<h5>Installing the following necessary prerequisites</h5>

    sudo apt update
    sudo apt install -y wordpress php libapache2-mod-php mysql-server php-mysq
    
<h5>Creating the Apache Site for Wordpress</h5>

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

<h5>Running below commands for enabling</h5>

    sudo a2ensite wordpress
    sudo a2enmod rewrite
    sudo service apache2 reload
    sudo systemctl enable apache2

<h5>Creating MySQL database</h5>

    sudo mysql -u root -e "CREATE DATABASE 'wordpress';"
    sudo mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost IDENTIFIED BY 'password';"
    sudo mysql -u root -e "FLUSH PRIVILEGES;
    
<h5>Configuring Wordpress to use the created database in previous step</h5>
    
    sudo echo "<?php
    define('DB_NAME', 'wordpress');
    define('DB_USER', 'wordpress');
    define('DB_PASSWORD', 'password');
    define('DB_HOST', 'localhost');
    define('DB_COLLATE', 'utf8_general_ci');
    define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
    ?>" > /etc/wordpress/config-localhost.php

    sudo systemctl enable mysql
    
    
<h5>Sending preconfigured config to WordPress (to avoid wordpress installation)</h5>

    sudo mysql --user=root --password=root wordpress < /vagrant/wordpress_db/wordpress.sql
    sudo rm -r /usr/share/wordpress/
    sudo ln -s /vagrant/wordpress /usr/share/ 

    sudo service mysql start
    
    
  
    
