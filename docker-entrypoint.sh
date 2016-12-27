#!/bin/sh
set -e

if [ "$XDEBUG_ENABLED" = true ]; then
    echo "Enabling xdebug extension"
    docker-php-ext-enable xdebug
    grep -q -F 'xdebug.idekey=PHPSTORM' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini || echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    grep -q -F 'xdebug.remote_enable=on' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini || echo 'xdebug.remote_enable=on' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

if [ "$1" = 'php-fpm' ]; then
    for f in /docker-entrypoint-initdb.d/*; do
	case "$f" in
	    *.sh)  echo "$0: running $f"; . "$f" ;;
	    *.php) echo "$0: running $f"; php "$f" && echo ;;
	    *)     echo "$0: ignoring $f" ;;
	 esac
	echo
    done
    exec gosu root "$@"
fi

exec "$@"
