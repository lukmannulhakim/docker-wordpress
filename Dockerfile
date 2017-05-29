FROM kucrut/php.nginx
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux."

# Install packages
RUN apk add --update mariadb-client imagemagick ghostscript php7-imagick && \
    rm -fr /var/cache/apk/*

# Set env vars
# This is needed for WP_CLI's --help argument to work.
# Still needs to fix the funny characters though.
ENV PAGER='busybox less'

# Configure nginx
COPY config/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

ENV WP_CLI_CONFIG_PATH=/wp-cli.yml

# wp-content volume
VOLUME /var/www/wp-content
RUN chown -R nobody.nobody /var/www

# Volume for extra WordPress configs.
RUN mkdir -p /var/www/wp-configs
VOLUME /var/www/wp-configs

# WP config
COPY config/wordpress/wp-config.php /var/www

# Install WP-CLI
RUN curl -o /usr/local/bin/wp -SL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli-nightly.phar && \
    chmod +x /usr/local/bin/wp

# Configure WP-CLI
COPY config/wordpress/wp-cli.yml /wp-cli.yml

# Download WordPress
RUN WP_VERSION=4.7.5 && \
    wp core download --allow-root --version="${WP_VERSION}" --force && \
    rm -rf /var/www/wordpress/default-themes && \
    mv /var/www/wordpress/wp-content/themes /var/www/wordpress/default-themes

# Volume for WP Core files, in case we want to use our local files.
VOLUME /var/www/wordpress
WORKDIR /var/www/wordpress

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
