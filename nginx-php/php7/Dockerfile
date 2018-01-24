FROM webdevops/php-apache-dev:alpine-php7

ADD ./nginx.conf /etc/nginx/

RUN echo "Europe/Madrid" > /etc/timezone

RUN touch /var/log/cron.log && \
    echo "* * * * * (php /var/www/html/modules/ximSYNC/scripts/scheduler/scheduler.php) 2>&1" >> mycron &&  crontab mycron && rm mycron
RUN crond
