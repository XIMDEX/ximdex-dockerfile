# Ximdex Dockerfile for debugging in PHP 7
Example for docker-compose.yml file:
```
version: "2"
services:
  myximdex:
    image: ximdex/nginx-php:php7-xdebug
    volumes:
      - ./:/var/www/html
    links:
      - db
    ports:
      - 8080:8080
    environment:
      WEB_DOCUMENT_ROOT: /var/www/html
```
