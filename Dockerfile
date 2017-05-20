FROM alpine:3.5
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux."

# Install packages
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "http://php.codecasts.rocks/7.1" >> /etc/apk/repositories && \
    apk add --update \
    nginx supervisor curl bash shadow \
    php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl php7-zlib \
    php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd php7-opcache && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    rm -fr /var/cache/apk/*

# Configure nginx
COPY config/nginx/nginx.conf          /etc/nginx/nginx.conf
COPY config/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

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

# Volume for extra WordPress configs.
RUN mkdir -p /var/www/wp-configs
VOLUME /var/www/wp-configs

# Install WP-CLI
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
    && chmod +x /usr/local/bin/wp

# Configure WP-CLI
COPY config/wordpress/wp-cli.yml /var/www/wp-configs/wp-cli.yml
ENV WP_CLI_CONFIG_PATH=/var/www/wp-configs/wp-cli.yml

ENV WP_VERSION 4.7.5

# Download WordPress
RUN wp core download \
    --allow-root \
    --version="${WP_VERSION}" \
    --force

# Volume for WP Core files, in case we want to use our local files.
VOLUME /var/www/wordpress

# WP config
COPY config/wordpress/wp-config.php /var/www

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
