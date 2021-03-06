# WordPress Docker Container

Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.1 on Alpine Linux.

_WordPress version currently installed:_ **4.9.1**

## Usage
See [docker-compose.yml](sample/) on how to use it in your own environment.
```
docker-compose up
```

Or
```
docker run -d \
    --name=wordpress_db \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=wordpress \
    -e MYSQL_USER=wordpress \
    -e MYSQL_PASSWORD=wordpress \
    kucrut/mariadb
docker run \
    --name=wordpress \
    --link wordpress_db:mysql \
    -p 80:80 \
    -e DB_HOST=wordpress_db \
    -e DB_NAME=wordpress \
    -e DB_USER=wordpress \
    -e DB_PASSWORD=wordpress \
    -v /some/local/path:/var/www/wp-content \
    kucrut/wordpress
```

### Credits
* https://github.com/TrafeX/docker-wordpress/
* https://php-alpine.codecasts.rocks/
