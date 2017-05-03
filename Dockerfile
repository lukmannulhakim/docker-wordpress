FROM alpine:3.5
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Lightweight WordPress container with Nginx 1.10 & PHP-FPM 7.1 based on Alpine Linux."

ENV WP_VERSION 4.7.4

# Install packages from testing repo's
RUN apk update && apk upgrade && apk add \
    nginx supervisor curl bash shadow \
    php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl php7-zlib \
    php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd php7-opcache && \
    rm -fr /var/cache/apk/*

RUN ln -s /usr/bin/php7 /usr/bin/php

# Configure nginx
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure PHP
COPY config/php/php.ini                 /etc/php7/conf.d/zzz-custom.ini
COPY config/php/conf.d/opcache.ini      /etc/php7/conf.d/opcache-recommended.ini
COPY config/php/php-fpm.d/global.conf   /etc/php7/php-fpm.d/zzz-global.conf
COPY config/php/php-fpm.d/www.conf      /etc/php7/php-fpm.d/zzz-www.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# wp-content volume
VOLUME /var/www/content
WORKDIR /var/www/content
RUN chown -R nobody.nobody /var/www

# Install wp-cli
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
    && chmod +x /usr/local/bin/wp

# Download WordPress
RUN wp core download \
    --allow-root \
    --path=/var/www/wordpress \
    --version="${WP_VERSION}" \
    --force

# Volume for WP Core files, in case we want to use our local files.
VOLUME /var/www/wordpress

# WP config
COPY config/wordpress/wp-config.php /var/www

# Volume for extra WordPress configs.
RUN mkdir -p /var/www/wp-configs
VOLUME /var/www/wp-configs

# Volumes for logs
VOLUME /var/log/nginx
VOLUME /var/log/php7

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
