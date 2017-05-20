FROM kucrut/php.nginx
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux."

# Configure nginx
COPY config/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

ENV WP_VERSION=4.7.5 \
    WP_CLI_CONFIG_PATH=/var/www/wp-configs/wp-cli.yml

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

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
