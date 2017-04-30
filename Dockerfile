FROM php:5.6-apache

RUN apt-get update \
 && apt-get install -y git libfreetype6-dev zlib1g-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libz-dev libmemcached-dev \
 && docker-php-ext-configure gd -with-freetype-dir=/usr/include/ -with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install mysqli \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install mcrypt \
 && docker-php-ext-install zip \
 && docker-php-ext-install gd \
 && docker-php-ext-install bcmath \
 #&& docker-php-ext-install opcache \
 && a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www!g' /etc/apache2/apache2.conf \
 && sed -i 's!/var/www/html!/var/www!g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's!/var/www/html!/var/www!g' /etc/apache2/sites-available/default-ssl.conf \
 && curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer
#RUN { \
#     echo 'opcache.memory_consumption=128'; \
#     echo 'opcache.interned_strings_buffer=8'; \
#     echo 'opcache.max_accelerated_files=10000'; \
#     echo 'opcache.revalidate_freq=60'; \
#     echo 'opcache.fast_shutdown=1'; \
#     echo 'opcache.enable_cli=1'; \
# } > /usr/local/etc/php/conf.d/opcache.ini
RUN { \
      echo 'realpath_cache_size=4096k'; \
      echo 'max_input_vars=10000'; \
      echo 'max_execution_time=120'; \
      echo 'mbstring.func_overload=2'; \
      echo 'mbstring.internal_encoding=UTF-8'; \
      echo 'date.timezone=Europe/Moscow'; \
 } > /usr/local/etc/php/conf.d/bitrix.ini
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable = 0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host = 192.168.3.106" >> /usr/local/etc/php/conf.d/xdebug.ini
RUN yes |pecl install memcache \
    && docker-php-ext-enable memcache
WORKDIR /var/www
