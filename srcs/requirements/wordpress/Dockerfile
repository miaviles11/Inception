FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-curl \
    php8.1-gd \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-soap \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Ajusta php-fpm para escuchar en 9000 (si usas socket cambia)
RUN mkdir -p /run/php && \
    sed -i 's/listen = .*$/listen = 9000/' /etc/php/8.1/fpm/pool.d/www.conf

WORKDIR /var/www/html

COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup.sh"]
