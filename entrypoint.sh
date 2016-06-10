#!/bin/bash

set -e

        if [ -n "$MYSQL_PORT_3306_TCP" ]; then
                if [ -z "$XIMDEX_DB_HOST" ]; then
                        XIMDEX_DB_HOST='mysql'
                else
                        echo >&2 "warning: both XIMDEX_DB_HOST and MYSQL_PORT_3306_TCP found"
                        echo >&2 "  Connecting to XIMDEX_DB_HOST ($XIMDEX_DB_HOST)"
                        echo >&2 "  instead of the linked mysql container"
                fi
        fi

        if [ -z "$XIMDEX_DB_HOST" ]; then
                echo >&2 "error: missing XIMDEX_DB_HOST and MYSQL_PORT_3306_TCP environment variables"
                echo >&2 "  Did you forget to --link some_mysql_container:mysql or set an external db"
                echo >&2 "  with -e XIMDEX_DB_HOST=hostname:port?"
                exit 1
        fi

        # If the DB user is 'root' then use the MySQL root password env var
        : ${XIMDEX_DB_USER:=root}
        if [ "$XIMDEX_DB_USER" = 'root' ]; then
                : ${XIMDEX_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
        fi
        : ${XIMDEX_DB_NAME:=ximdex}

        if [ -z "$XIMDEX_DB_PASSWORD" ]; then
                echo >&2 "error: missing required XIMDEX_DB_PASSWORD environment variable"
                echo >&2 "  Did you forget to -e XIMDEX_DB_PASSWORD=... ?"
                echo >&2
                echo >&2 "  (Also of interest might be XIMDEX_DB_USER and XIMDEX_DB_NAME.)"
                exit 1
        fi
        if ! [ -e index.php -a -e conf/install-params.conf.php ]; then
                echo >&2 "Ximdex not found in $(pwd) - copying now..."

                if [ "$(ls -A)" ]; then
                        echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
                        ( set -x; ls -A; sleep 10 )
                fi

                tar cf - --one-file-system -C /usr/src/ximdex . | tar xf -

                if [ ! -e .htaccess ]; then
                        # NOTE: The "Indexes" option is disabled in the php:apache base image so remove it as we enable .htaccess
                        sed -r 's/^(Options -Indexes.*)$/#\1/' htaccess.txt > .htaccess
                        chown www-data:www-data .htaccess
                fi

                array=("${XIMDEX_DB_HOST//:/ }")
                HOST="${array[0]}"
                PORT="3306"
                
                if [ -n "${array[1]}" ]; then
                       PORT="${array[1]}" 
                fi

                # Setting dbconfig
                echo "{\"dbname\": \"$XIMDEX_DB_NAME\",\"dbhost\": \"$HOST\",\"dbport\": \"$PORT\",\"dbuser\": \"$XIMDEX_DB_USER\",\"dbpass\": \"$XIMDEX_DB_PASSWORD\"}" > /var/www/html/setup/data/config.json

                echo >&2 "Complete! Ximdex has been successfully copied to $(pwd)"
        fi

        # Ensure the MySQL Database is created
        php /makedb.php "$XIMDEX_DB_HOST" "$XIMDEX_DB_USER" "$XIMDEX_DB_PASSWORD" "$XIMDEX_DB_NAME"

        echo >&2 "========================================================================"
        echo >&2
        echo >&2 "This server is now configured to run Ximdex!"
        echo >&2 "You will need the following database information to install Ximdex:"
        echo >&2 "Host Name: $XIMDEX_DB_HOST"
        echo >&2 "Database Name: $XIMDEX_DB_NAME"
        echo >&2 "Database Username: $XIMDEX_DB_USER"
        echo >&2 "Database Password: $XIMDEX_DB_PASSWORD"
        echo >&2
        echo >&2 "========================================================================"

service cron start

exec "$@"