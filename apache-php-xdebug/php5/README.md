# Ximdex Dockerfile for debugging in PHP 5
Example:
```
services:
  myximdex:
    image: ximdex/nginx-php:php5-xdebug
    volumes:
      - ./:/var/www/html
    links:
      - db
    ports:
      - 8080:80
    environment:
      WEB_DOCUMENT_ROOT: /var/www/html
   	...
```