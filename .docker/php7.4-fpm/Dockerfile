ARG DOCKER_PHP_VERSION
FROM php:${DOCKER_PHP_VERSION}-fpm

WORKDIR /app

###
### Envs
###
ENV MY_USER="app" \
	MY_GROUP="app"

ARG DOCKER_IMAGE_VERSION
ARG DOCKER_SERVER_HOST
ARG DOCKER_SERVER_PORT
ARG DOCKER_PROJECT_PATH
ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

###
### User/Group
###
RUN set -eux \
	&& groupadd -g ${DOCKER_GID} -r ${MY_GROUP} \
	&& useradd -d /home/${MY_USER} -u ${DOCKER_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}


###
### Upgrade (install ps)
###
RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
	    procps \
	    curl \
	    apt-utils


# php settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini

# php extensions

# -------------------- Installing PHP Extension: mcrypt --------------------
RUN set -eux \
	# Installation: Version specific
	# Type:         PECL extension
	# Default:      Pecl command
	&& apt-get install -y libmcrypt-dev \
	&& pecl install mcrypt \
	# Enabling
	&& docker-php-ext-enable mcrypt \
	&& true

# -------------------- Installing PHP Extension: bcmath --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath \
	&& true

# -------------------- Installing PHP Extension: sockets --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sockets \
	&& true


# -------------------- Installing PHP Extension: intl --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
	&& true

# -------------------- Installing PHP Extension: opcache --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) opcache \
	&& true

# -------------------- Installing PHP Extension: redis --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         PECL extension
	# Default:      Pecl command
	&& pecl install redis \
	# Enabling
	&& docker-php-ext-enable redis \
	&& true

# -------------------- Installing PHP Extension: zip --------------------
RUN set -eux \
	# Installation: Version specific
	# Type:         Built-in extension
	# Custom:       configure command
	&& apt-get install -y libzip-dev \
	&& docker-php-ext-configure zip --with-zip \
	# Installation
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
	&& true


# -------------------- Installing PHP Extension: pdo_mysql --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	# Custom:       configure command
	&& docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
	&& true

# -------------------- Installing PHP Extension: pcntl --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pcntl \
	&& true

# -------------------- Installing PHP Extension: mbstring --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& apt-get install -y libonig-dev \
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mbstring \
	&& true

# -------------------- Installing PHP Extension: json --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         Built-in extension
	&& docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) json \
	&& true

# -------------------- Delete extracted php source --------------------
RUN set -eux \
    && docker-php-source delete \
    && true
