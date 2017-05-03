# WordPress Docker Container

WordPress container with Nginx 1.10 & PHP-FPM 7.1 on Alpine Linux.

_WordPress version currently installed:_ **4.7.4**

## Usage
See docker-compose.yml how to use it in your own environment.

    docker-compose up

Or

    docker run -d -p 80:80 -v /local/folder:/var/www/wp-content -e "DB_HOST=db" -e "DB_NAME=wordpress" -e "DB_USER=wp" -e "DB_PASSWORD=secret" kucrut/wordpress

### Credits
* https://github.com/TrafeX/docker-wordpress/
