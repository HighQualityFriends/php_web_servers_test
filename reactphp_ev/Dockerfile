FROM php:7.1-alpine
RUN docker-php-ext-install pcntl sockets mbstring bcmath && \
    mkdir /app && chown www-data:www-data /app
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS && \
    pecl install ev-1.0.4 && \
    docker-php-ext-enable ev --ini-name "pecl-docker-php-ext-ev.ini" && \
    rm -rf /tmp/pear && apk del .phpize-deps
COPY --chown=www-data:www-data vendor /app/vendor
COPY --chown=www-data:www-data src /app/src
COPY --chown=www-data:www-data reactphp_server.php /app
USER www-data
WORKDIR /app
ENTRYPOINT ["php", "reactphp_server.php"]
