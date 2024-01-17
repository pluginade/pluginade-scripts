FROM php:8.2-fpm

# Install unzip utility and libs needed by zip PHP extension 
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip \
    git \
    zip

RUN docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install node and npm. The version here should match the version used by Gutenberg here:
# https://github.com/WordPress/gutenberg/blob/trunk/.nvmrc
# But also be kept up to date with the latest 14.something version here:
# https://nodejs.org/en/blog/release/
ENV NODE_VERSION=14.20.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Make a directory for us to work.
RUN mkdir -p /usr/src/pluginade
WORKDIR /usr/src/pluginade/pluginade-scripts

