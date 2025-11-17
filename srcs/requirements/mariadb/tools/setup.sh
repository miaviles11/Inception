#!/bin/bash

# Verificar si la base de datos de WordPress ya existe
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB..."
    
    # Iniciar MariaDB en segundo plano temporalmente
    mysqld --user=mysql --skip-networking --socket=/tmp/mysql_init.sock &
    MYSQL_PID=$!
    
    # Esperar a que MariaDB esté lista
    for i in {1..30}; do
        if mysql --socket=/tmp/mysql_init.sock -e "SELECT 1" &>/dev/null; then
            break
        fi
        echo "Waiting for MySQL to start..."
        sleep 1
    done
    
    # Configurar root y crear BD
    mysql --socket=/tmp/mysql_init.sock -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # Parar MySQL temporal
    kill $MYSQL_PID
    wait $MYSQL_PID
    
    echo "MariaDB initialized!"
else
    echo "MariaDB already initialized!"
fi

# Arrancar MariaDB normalmente
exec mysqld --user=mysql