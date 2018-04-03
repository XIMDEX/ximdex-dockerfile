FROM webdevops/php-apache-dev:alpine-php7

# RUN service apache2 stop
# RUN apt-get update
# RUN apt-get -y install software-properties-common
# RUN apt-get install php7-xdebug
# RUN echo "xdebug.remote_enable=on" >> /etc/php7/mods-available/xdebug.ini \
# 	&& echo "xdebug.remote_autostart=on" >> /etc/php7/mods-available/xdebug.ini \
# 	&& echo "xdebug.remote_connect_back=on" >> /etc/php7/mods-available/xdebug.ini
# RUN service apache2 restart

RUN echo "Europe/Madrid" > /etc/timezone

RUN touch /var/log/cron.log && \
    echo "* * * * * php /var/www/html/bootstrap.php modules/ximSYNC/scripts/scheduler/scheduler.php" >> mycron && \ 
    crontab mycron && rm mycron

RUN crond