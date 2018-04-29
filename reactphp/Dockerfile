FROM php:7.1-alpine
RUN apk add --no-cache libevent
RUN docker-php-ext-install pcntl sockets mbstring bcmath
RUN mkdir /app && chown www-data:www-data /app
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS libevent-dev openssl-dev && \
    pecl install event-2.3.0 && \
    docker-php-ext-enable event --ini-name "pecl-docker-php-ext-event.ini" && \
    rm -rf /tmp/pear && apk del .phpize-deps

COPY --chown=www-data:www-data vendor /app/vendor
COPY --chown=www-data:www-data src /app/src
COPY --chown=www-data:www-data reactphp_server.php /app
USER www-data
WORKDIR /app
ENTRYPOINT ["php", "reactphp_server.php"]
