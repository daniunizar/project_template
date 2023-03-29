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

# Xdebug
ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; \
    then \
        apk add --update linux-headers && \
        pecl install xdebug && \
        docker-php-ext-enable xdebug; \
    fi

COPY docker/staging/php-fpm/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY docker/staging/php-fpm/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

RUN apk add --no-cache libpq-dev zlib-dev g++ git icu-dev zip libzip-dev libpng-dev zip \
    && docker-php-ext-install intl opcache pdo pdo_mysql gd \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# Configure non-root user.
ARG PUID=1000
ARG PGID=1000
RUN apk --no-cache add shadow && \
    groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

WORKDIR /var/www

# Source code
RUN chown www-data:www-data /var/www
COPY --chown=www-data:www-data ./ /var/www

# Installing Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar composer && \
    chown www-data:www-data composer

## Configuring Supervisor
RUN mkdir /etc/supervisor.d/ && \
    touch /var/log/supervisord.log && \
    chown www-data /etc/supervisord.conf /var/log/supervisord.log && \
    sed -i 's#file=/run/#file=/tmp/#g' /etc/supervisord.conf
COPY --chown=www-data:root ./docker/staging/php-fpm/supervisor-php.ini /etc/supervisor.d/

USER www-data

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
