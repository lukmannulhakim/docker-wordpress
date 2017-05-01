FROM alpine:edge
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Lightweight WordPress container with Nginx 1.10 & PHP-FPM 7.1 based on Alpine Linux."

ENV WP_VERSION 4.7.4
ENV WP_CORE_DIR /usr/src/wordpress

# Install packages from testing repo's
RUN apk upgrade -U -a && \
    apk --no-cache add \
    nginx supervisor curl bash \
    php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl php7-zlib \
    php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd

# Small fixes
RUN ln -s /etc/php7 /etc/php && \
    ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/lib/php7 /usr/lib/php && \
	rm -fr /var/cache/apk/*

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# wp-content volume
VOLUME /var/www/wp-content
WORKDIR /var/www/wp-content
RUN chown -R nobody.nobody /var/www

RUN mkdir -p /usr/src

# Install wp-cli
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
    && chmod +x /usr/local/bin/wp

# Download WordPress
RUN wp core download \
    --allow-root \
    --path=${WP_CORE_DIR} \
    --version="${WP_VERSION}" \
    --force

# WP config
COPY wp-config.php ${WP_CORE_DIR}
RUN chown nobody.nobody /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
COPY wp-secrets.php ${WP_CORE_DIR}
RUN chown nobody.nobody /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
