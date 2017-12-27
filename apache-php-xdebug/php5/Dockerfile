FROM webdevops/php-apache:ubuntu-14.04

RUN service apache2 stop
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN apt-get install php5-xdebug

RUN echo "xdebug.remote_enable=on" >> /etc/php5/mods-available/xdebug.ini \
	&& echo "xdebug.remote_autostart=on" >> /etc/php5/mods-available/xdebug.ini \
	&& echo "xdebug.remote_connect_back=on" >> /etc/php5/mods-available/xdebug.ini

RUN service apache2 restart

RUN echo "Europe/Madrid" > /etc/timezone

RUN touch /var/log/cron.log && \
    echo "* * * * * (php /var/www/html/ximdexWEB/modules/ximSYNC/scripts/scheduler/scheduler.php) 2>&1" >> mycron && \
    echo "* * * * * (php /var/www/html/ximdexRMCS/modules/ximSYNC/scripts/scheduler/scheduler.php) 2>&1" >> mycron && \
    echo "* * * * * (php /var/www/html/ximdexRMCS/modules/ximNEWS/actions/generatecolector/automatic.php) 2>&1" >> mycron && crontab mycron && rm mycron