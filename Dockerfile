FROM php:5.6-apache

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        git \
        libx11-dev \
        mesa-common-dev \
        libglu1-mesa-dev \
        libxrandr-dev \
        libxi-dev \
        wget \
        unzip \
        mysql-client \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g-dev \
        libzip-dev \
        libxml2-dev \
        ssh \
    ; \
    \
    wget -c \
        https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.gz \
        -O /tmp/freetype-2.10.0.tar.gz \
        && cd /tmp \
        && tar zxvf /tmp/freetype-2.10.0.tar.gz \
        && cd /tmp/freetype-2.10.0 \
        && ./configure --enable-freetype-config \
        && make \
        && make install; \
    cd; \
    rm /tmp/freetype-2.10.0.tar.gz; \
    rm -rf /tmp/freetype-2.10.0; \
    \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
    ; \
    \
    docker-php-ext-install -j$(nproc) \
        iconv \
        opcache \
        zip \
        gd \
        mysql \
        pcntl \
        calendar \
        json \
        soap \
        sockets \
    ; \
    \
    wget -c https://pecl.php.net/get/redis-4.3.0.tgz -O /tmp/redis-4.3.0.tgz \
        && cd /tmp \
        && tar zxvf /tmp/redis-4.3.0.tgz \
        && cd /tmp/redis-4.3.0 \
        && phpize \
        && ./configure \
        && make \
        && make install; \
        cd; \
        rm /tmp/redis-4.3.0.tgz; \
        rm -rf /tmp/redis-4.3.0; \
        docker-php-ext-enable redis; \
    \
    cd /tmp && \
    git clone --recursive git://git.ghostscript.com/mupdf.git && \
    cd mupdf && \
    make prefix=/usr/local install && \
    cd /tmp && \
    rm -rf mupdf ; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

