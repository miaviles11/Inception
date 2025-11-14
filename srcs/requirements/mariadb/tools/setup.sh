#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB..."

	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	mysqld --user=mysql --bootstrap << EOF

USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "MariaDB initialized!"
fi

exec mysqld --user=mysql
