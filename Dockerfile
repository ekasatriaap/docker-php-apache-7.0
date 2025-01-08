# Menggunakan image dasar PHP dengan Apache
FROM php:7.0-apache

# Mengubah sumber repositori ke archive.debian.org dan menghapus repositori yang tidak diperlukan
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/d' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Menjaga agar paket sistem tetap up-to-date
RUN apt-get update && apt-get upgrade -y

# Menginstal paket sistem yang dibutuhkan
RUN apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libmcrypt-dev \
    libxml2-dev \
    libicu-dev \
    libxslt1-dev \
    libzip-dev \
    zlib1g-dev \
    unzip \
    git \
    curl \
    vim \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) iconv mcrypt gd pdo pdo_mysql mysqli zip intl soap xsl bcmath

# Mengaktifkan modul Apache yang diperlukan
RUN a2enmod rewrite headers

# Menyalin file konfigurasi Apache (jika ada)
# COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Mengatur direktori kerja
WORKDIR /var/www/html

# Menyalin kode aplikasi ke dalam container
# COPY . /var/www/html

# Memberikan izin yang sesuai untuk direktori aplikasi
RUN chown -R www-data:www-data /var/www/html

# Mengekspos port yang digunakan oleh Apache
EXPOSE 80

# Perintah untuk menjalankan Apache
CMD ["apache2-foreground"]
