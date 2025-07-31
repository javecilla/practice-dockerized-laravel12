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
    chmod +x artisan
    
    # Set directory permissions
    find . -type d -exec chmod 755 {} \;
    
    # Ensure storage and bootstrap/cache are writable
    chmod -R 775 storage bootstrap/cache
    chown -R ${USER_ID}:${GROUP_ID} storage bootstrap/cache
    
    # Switch to laravel user and keep container running
    exec gosu ${USER_ID}:${GROUP_ID} tail -f /dev/null
}

# Main entrypoint logic
case "$1" in
    serve)
        echo "Starting workspace container..."
        setup_laravel
        ;;
    *)
        exec "$@"
        ;;
esac
