FROM php:7-fpm-alpine
MAINTAINER "Ryan Paddock <rpaddock@gmail.com>"

EXPOSE 9000

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache \
        libmcrypt \
        freetype \
        libjpeg-turbo \
        libpng \
        gosu@testing

RUN apk add --no-cache --virtual build-dependencies \
    libmcrypt-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    zlib-dev

RUN docker-php-ext-install \
    mcrypt \
    mysqli \
    pdo_mysql \
    mbstring \
    zip \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu \
        --with-png-dir=/usr/lib/x86_64-linux-gnu \
        --with-freetype-dir=/usr/lib/x86_64-linux-gnu \
    && docker-php-ext-install gd \
    && apk add --no-cache phpredis@testing

RUN apk del --force build-dependencies

RUN cat /usr/src/php/php.ini-production | sed 's/^;\(date.timezone.*\)/\1 \"Etc\/UTC\"/' > /usr/local/etc/php/php.ini
RUN sed -i 's/;\(cgi\.fix_pathinfo=\)1/\10/' /usr/local/etc/php/php.ini

WORKDIR /var/www

RUN mkdir /docker-entrypoint-initdb.d
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
