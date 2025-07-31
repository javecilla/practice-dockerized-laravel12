FROM httpd:2.4

# Install required packages
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN sed -i '/LoadModule rewrite_module/s/^#//g' /usr/local/apache2/conf/httpd.conf \
    && sed -i '/LoadModule proxy_module/s/^#//g' /usr/local/apache2/conf/httpd.conf \
    && sed -i '/LoadModule proxy_fcgi_module/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy virtual host configuration
COPY docker/production/apache/000-default.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Enable virtual hosts and set production-specific settings
RUN echo "Include conf/extra/httpd-vhosts.conf" >> /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/ServerTokens OS/ServerTokens Prod/' /usr/local/apache2/conf/httpd.conf \
    && sed -i 's/ServerSignature On/ServerSignature Off/' /usr/local/apache2/conf/httpd.conf
