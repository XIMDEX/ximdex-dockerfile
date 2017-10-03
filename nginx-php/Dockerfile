FROM webdevops/php-nginx:alpine-php7

ADD ./nginx.conf /etc/nginx/

# RUN apk add --no-cache enchant
# RUN apk add --no-cache openssl

RUN echo "Europe/Madrid" > /etc/timezone

RUN touch /var/log/cron.log && \
    echo "* * * * * (php /var/www/html/modules/ximSYNC/scripts/scheduler/scheduler.php) >> /var/www/html/logs/scheduler.log 2>&1" >> mycron && \
	crontab mycron && \
	rm mycron
RUN crond