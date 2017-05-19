# WordPress Docker Container

Minimalist WordPress container with NGINX 1.10 & PHP-FPM 7.0 on Alpine Linux.

_WordPress version currently installed:_ **4.7.5**

## Usage
See [docker-compose.yml](sample/) how to use it in your own environment.
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
    mariadb:10.1
docker run \
    --name=wordpress \
    --link wordpress_db:mysql \
    -p 80:80 \
    -e DB_HOST=wordpress_db \
    -e DB_NAME=wordpress \
    -e DB_USER=wordpress \
    -e DB_PASSWORD=wordpress \
    -v /some/local/path:/var/www/content \
    kucrut/wordpress
```

### Credits
* https://github.com/TrafeX/docker-wordpress/
