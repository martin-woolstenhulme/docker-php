FROM php:7.1-fpm-alpine
MAINTAINER "Ryan Paddock <rpaddock@gmail.com>"


RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache \
        freetype \
        gosu \
        libjpeg-turbo \
        libmcrypt \
        libpng \
        shadow \
    && apk add --no-cache --virtual build-dependencies \
        autoconf \
        freetype-dev \
        g++ \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        make \
        zlib-dev \
    && docker-php-ext-install \
        mcrypt \
        mysqli \
        pdo_mysql \
        zip \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu \
        --with-png-dir=/usr/lib/x86_64-linux-gnu \
        --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
    && docker-php-ext-install gd \
    && pecl install redis \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable redis \
    && apk del --force build-dependencies \
    && usermod -u 1000 www-data \
    && mkdir /docker-entrypoint-initdb.d

COPY php.ini-production /usr/local/etc/php/php.ini
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /var/www

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
