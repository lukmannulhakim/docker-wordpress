FROM kucrut/php.nginx
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux."

# Install packages
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "http://php.codecasts.rocks/7.1" >> /etc/apk/repositories && \
    apk add --update imagemagick ghostscript php7-imagick && \
    rm -fr /var/cache/apk/*


# Set env vars
# This is needed for WP_CLI's --help argument to work.
# Still needs to fix the funny characters though.
ENV PAGER='busybox less'

# Configure nginx
COPY config/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

ENV WP_VERSION=4.7.5 \
    WP_CLI_CONFIG_PATH=/wp-cli.yml

# wp-content volume
VOLUME /var/www/wp-content
RUN chown -R nobody.nobody /var/www

# Volume for extra WordPress configs.
RUN mkdir -p /var/www/wp-configs
VOLUME /var/www/wp-configs

# Install WP-CLI
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar \
    && chmod +x /usr/local/bin/wp

# Configure WP-CLI
COPY config/wordpress/wp-cli.yml /wp-cli.yml

# Download WordPress
RUN wp core download \
    --allow-root \
    --version="${WP_VERSION}" \
    --force

# Volume for WP Core files, in case we want to use our local files.
VOLUME /var/www/wordpress
WORKDIR /var/www/wordpress

# WP config
COPY config/wordpress/wp-config.php /var/www

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
