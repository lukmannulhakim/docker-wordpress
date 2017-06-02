FROM kucrut/php.nginx
LABEL Maintainer="Dzikri Aziz <kvcrvt@gmail.com>" \
      Description="Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux."

# Install packages
RUN apk add --update mariadb-client imagemagick ghostscript php7-imagick && \
    rm -fr /var/cache/apk/*

# Configure nginx
COPY config/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Volume for extra WordPress configs.
RUN mkdir -p /var/www/wp-configs
VOLUME /var/www/wp-configs

# WP & WP-CLI configs
COPY config/wordpress/* /var/www/

# Configure WP-CLI
# PAGER is needed for WP-CLI's --help argument to work.
# Still needs to fix the funny characters though.
ENV PAGER='busybox less' \
    WP_CLI_CONFIG_PATH=/var/www/wp-cli.yml

# Install WP-CLI
RUN WP_CLI_VERSION=1.2.0 && \
    curl -o /usr/local/bin/wp -SL "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar" && \
    chmod +x /usr/local/bin/wp

# Download WordPress
RUN WP_VERSION=4.7.5 && \
    wp core download --allow-root --version="${WP_VERSION}" --force && \
    mv /var/www/wordpress/wp-content/themes /var/www/wordpress/default-themes

# Volume for wp-content
VOLUME /var/www/wp-content

# Volume for WP Core files, in case we want to use our local files.
VOLUME /var/www/wordpress
WORKDIR /var/www/wordpress

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
