#!/bin/bash
set -e

# Function to setup Laravel directories and permissions
setup_laravel() {
    echo "Setting up Laravel directories and permissions..."
    cd /var/www/html
    
    # Create storage directory structure if it does not exist
    mkdir -p storage/logs storage/framework/{sessions,views,cache}
    
    # Set ownership to laravel user (using environment variables)
    chown -R ${USER_ID}:${GROUP_ID} .
    
    # Set base permissions for files
    find . -type f -exec chmod 644 {} \;
    
    # Add execute where needed
    find . -type f -name "*.sh" -exec chmod +x {} \;
    if [ -f "artisan" ]; then
        chmod +x artisan
    fi
    
    # Set directory permissions
    find . -type d -exec chmod 755 {} \;
    
    # Ensure storage and bootstrap/cache are writable
    chmod -R 775 storage bootstrap/cache
    chown -R ${USER_ID}:${GROUP_ID} storage bootstrap/cache

    echo "Starting workspace container..."
}

# Main entrypoint logic
case "$1" in
    serve)
        setup_laravel
        if [ -f "artisan" ]; then
            exec gosu ${USER_ID}:${GROUP_ID} php artisan serve --host=0.0.0.0 --port=8000
        else
            echo "Laravel artisan not found. Container will exit."
            exit 1
        fi
        ;;
    *)
        setup_laravel
        exec gosu ${USER_ID}:${GROUP_ID} "$@"
        ;;
esac
