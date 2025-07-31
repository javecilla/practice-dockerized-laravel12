#!/bin/sh
set -e

# Install/update Composer dependencies
if [ -f "composer.json" ]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

# Run Laravel optimization commands if in production
if [ "$APP_ENV" = "production" ]; then
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

# Generate application key if not set
if [ -z "$APP_KEY" ]; then
    php artisan key:generate
fi

# Run migrations if database is ready
if [ "$DB_CONNECTION" = "mysql" ]; then
    while ! nc -z $DB_HOST $DB_PORT; do
        echo "Waiting for database to be ready..."
        sleep 1
    done
    php artisan migrate --force
fi

exec "$@"
