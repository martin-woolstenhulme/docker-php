#!/bin/sh
set -e

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
