# Set the base image to use to Ubuntu
FROM php:7.0-apache

# Set the file maintainer
MAINTAINER Ximdex ximdex

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Updating the repository list
RUN apt-get update && apt-get install -y unzip cron libicu-dev libcurl4-gnutls-dev pwgen python-setuptools gettext libpng12-dev libmcrypt-dev libjpeg-dev libxml2-dev libxslt-dev \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gettext pdo pdo_mysql curl xmlrpc gd intl xsl mcrypt mysqli opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

VOLUME /var/www/html

# Cloning Ximdex CMS from GitHub in /var/www/html
RUN curl -o ximdex.zip -SL https://github.com/XIMDEX/ximdex/archive/develop.zip && \
		unzip ximdex.zip -d /usr/src/ && \
		mv /usr/src/ximdex-develop /usr/src/ximdex && \
		rm -f ximdex.zip && \
		# Setting permissions
		chown -R www-data:www-data /usr/src/ximdex && \
		chmod -R 2770 /usr/src/ximdex/data && \
		chmod -R 2770 /usr/src/ximdex/conf && \
		chmod -R 2770 /usr/src/ximdex/logs && \
		line="* * * * * (php /var/www/html/modules/ximSYNC/scripts/scheduler/scheduler.php) >>  /var/www/html/logs/scheduler.log 2>&1" && \
		(crontab -u root -l; echo "$line" ) | crontab -u root -
		
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
COPY makedb.php /makedb.php

RUN touch /usr/local/etc/php/conf.d/docker-php-ext-prod.ini && echo 'display_errors=0' > /usr/local/etc/php/conf.d/docker-php-ext-prod.ini

# Installing supervisor
RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-n"]
