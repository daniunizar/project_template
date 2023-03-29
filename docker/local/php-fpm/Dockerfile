FROM php:8.2.4-fpm-alpine3.17

# Install packages
RUN apk add --no-cache \
    curl \
    git \
    build-base \
    zlib-dev \
    oniguruma-dev \
    autoconf \
    bash \
    supervisor

## Configurating Xdebug
ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; \
   then \
     apk add --update linux-headers && \
     pecl install xdebug && \
     docker-php-ext-enable xdebug; \
   fi;

COPY ./docker/local/php-fpm/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./docker/local/php-fpm/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

RUN apk add --no-cache libpq-dev zlib-dev g++ git icu-dev zip libzip-dev libpng-dev zip \
    && docker-php-ext-install intl opcache pdo pdo_mysql gd \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

WORKDIR /var/www

## Installing Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

## Configuring Supervisor
RUN mkdir /etc/supervisor.d/
COPY ./docker/local/php-fpm/supervisor-php.ini /etc/supervisor.d/

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
