FROM webdevops/php-apache-dev:alpine-php7

ADD ./nginx.conf /etc/nginx/

RUN echo "Europe/Madrid" > /etc/timezone

RUN touch /var/log/cron.log && \
    echo "* * * * * php /var/www/html/bootstrap.php src/Sync/scripts/scheduler/scheduler.php" >> mycron &&  crontab mycron && rm mycron

RUN crond