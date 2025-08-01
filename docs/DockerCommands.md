# Docker Commands Reference Guide

This document provides a comprehensive list of Docker commands commonly used in this Laravel project.

## Basic Container Management

### Starting the Environment
```bash
# Start development environment
docker compose -f compose.dev.yaml up -d
# Start and rebuild containers
docker compose -f compose.dev.yaml up -d --build
# Start production environment
docker compose -f compose.prod.yaml up -d
```

### Stopping the Environment
```bash
# Stop development containers
docker compose -f compose.dev.yaml down
# Stop and remove volumes (caution: deletes data)
docker compose -f compose.dev.yaml down -v
# Stop production containers
docker compose -f compose.prod.yaml down
```

### Container Status and Information
```bash
# List project containers and their status
docker compose -f compose.dev.yaml ps
# List all Docker containers (running and stopped)
docker ps -a
# Show only running containers
docker ps
# View real-time container resource usage
docker stats
# Show container port mappings
docker compose -f compose.dev.yaml ports
# View container logs in real-time
docker compose -f compose.dev.yaml logs -f
```

### Image Management
```bash
# List all images
docker images
# Remove specific image
docker rmi [image_name]
# Remove all unused images
docker image prune -a
# Build specific service
docker compose -f compose.dev.yaml build workspace
# Pull latest images
docker compose -f compose.dev.yaml pull
```

### Network Commands
```bash
# List networks
docker network ls
# Inspect network
docker network inspect laravel-development
# Remove unused networks
docker network prune
# Create new network
docker network create [network_name]
```

### Volume Commands
```bash
# List volumes
docker volume ls
# Inspect volume
docker volume inspect dockerized_laravel_dev-mysql-data
# Remove specific volume
docker volume rm [volume_name]
# Remove all unused volumes
docker volume prune
```

### Container Runtime Commands
```bash
# Stop specific container
docker compose -f compose.dev.yaml stop workspace
# Start specific container
docker compose -f compose.dev.yaml start workspace
# Restart specific container
docker compose -f compose.dev.yaml restart workspace
# Pause container
docker compose -f compose.dev.yaml pause [service_name]
# Unpause container
docker compose -f compose.dev.yaml unpause [service_name]
```

### Troubleshooting Commands
```bash
# View container events
docker events
# View compose logs for specific service
docker compose -f compose.dev.yaml logs workspace
# Follow log output
docker compose -f compose.dev.yaml logs -f workspace
# Show container resource consumption
docker compose -f compose.dev.yaml top
# To verify the permissions are correct
docker exec dockerized_laravel_dev-apache ls -la /var/www/html/storage
```

### Docker System Commands
```bash
# Show Docker system information
docker info
# Show Docker disk usage
docker system df
# Clean up everything not in use
docker system prune -a --volumes
# Show Docker version and info
docker version
```

### Service Scaling (if needed)
```bash
# Scale specific service
docker compose -f compose.dev.yaml up -d --scale php-fpm=2
# View running instances
docker compose -f compose.dev.yaml ps php-fpm
```

## Container-Specific Commands

### Apache Container
```bash
# View Apache logs
docker logs dockerized_laravel_dev-apache
# Access Apache container shell
docker exec -it dockerized_laravel_dev-apache bash
# Reload Apache configuration
docker exec dockerized_laravel_dev-apache apachectl -k graceful
```

### PHP-FPM Container
```bash
# View PHP-FPM logs
docker logs dockerized_laravel_dev-php-fpm
# Check PHP-FPM status
docker exec dockerized_laravel_dev-php-fpm php-fpm -t
# Access PHP-FPM container
docker exec -it dockerized_laravel_dev-php-fpm bash
```

### MySQL Container
```bash
# Access MySQL CLI
docker exec -it dockerized_laravel_dev-mysql mysql -uroot -p4545
# View MySQL logs
docker logs dockerized_laravel_dev-mysql
# Import database
docker exec -i dockerized_laravel_dev-mysql mysql -uroot -p4545 docker_test_db < backup.sql
# Export database
docker exec dockerized_laravel_dev-mysql mysqldump -uroot -p4545 docker_test_db > backup.sql
```

### Redis Container
```bash
# Access Redis CLI
docker exec -it dockerized_laravel_dev-redis redis-cli
# Monitor Redis commands
docker exec -it dockerized_laravel_dev-redis redis-cli monitor
# View Redis logs
docker logs dockerized_laravel_dev-redis
```

## Laravel Commands (Workspace Container)

### Composer Commands
```bash
# Install dependencies
docker exec dockerized_laravel_dev-workspace composer install
# Update dependencies
docker exec dockerized_laravel_dev-workspace composer update
# Add new package
docker exec dockerized_laravel_dev-workspace composer require vendor/package
```

### Artisan Commands
```bash
# Generate application key
docker exec dockerized_laravel_dev-workspace php artisan key:generate
# Run migrations
docker exec dockerized_laravel_dev-workspace php artisan migrate
# Fresh migrations with seeders
docker exec dockerized_laravel_dev-workspace php artisan migrate:fresh --seed
# Create new migration
docker exec dockerized_laravel_dev-workspace php artisan make:migration create_table_name
# Create new controller
docker exec dockerized_laravel_dev-workspace php artisan make:controller ControllerName
# Create new model
docker exec dockerized_laravel_dev-workspace php artisan make:model ModelName
```

### Cache Commands
```bash
# Clear application cache
docker exec dockerized_laravel_dev-workspace php artisan cache:clear
# Clear config cache
docker exec dockerized_laravel_dev-workspace php artisan config:clear
# Clear route cache
docker exec dockerized_laravel_dev-workspace php artisan route:clear
# Clear view cache
docker exec dockerized_laravel_dev-workspace php artisan view:clear
# Clear all caches
docker exec dockerized_laravel_dev-workspace php artisan optimize:clear
```

### NPM Commands
```bash
# Install NPM dependencies
docker exec dockerized_laravel_dev-workspace npm install
# Run development build
docker exec dockerized_laravel_dev-workspace npm run dev
# Run production build
docker exec dockerized_laravel_dev-workspace npm run build
# Watch for changes
docker exec dockerized_laravel_dev-workspace npm run watch
```

## Maintenance Commands

### Storage Permissions
```bash
# Fix storage permissions
docker exec dockerized_laravel_dev-workspace chown -R www-data:www-data storage bootstrap/cache
# Set proper permissions for storage directory
docker exec dockerized_laravel_dev-workspace chmod -R 775 storage bootstrap/cache
```

### Log Access
```bash
# View Laravel logs
docker exec dockerized_laravel_dev-workspace tail -f storage/logs/laravel.log
# Clear log file
docker exec dockerized_laravel_dev-workspace truncate -s 0 storage/logs/laravel.log
```

### Container Cleanup
```bash
# Remove unused containers
docker container prune
# Remove unused volumes
docker volume prune
# Remove unused networks
docker network prune
# Remove all unused resources
docker system prune
```

## Debugging Commands

### Container Inspection
```bash
# View container details
docker inspect dockerized_laravel_dev-workspace
# View container network settings
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name
```

### Resource Monitoring
```bash
# View container resource usage
docker stats dockerized_laravel_dev-workspace
# View running processes in container
docker top dockerized_laravel_dev-workspace
```

### Health Checks
```bash
# Check MySQL connection
docker exec dockerized_laravel_dev-workspace php artisan db:monitor
# Check Redis connection
docker exec dockerized_laravel_dev-workspace php artisan redis:monitor
```

## Production-Specific Commands

### Deployment
```bash
# Build production images
docker compose -f compose.prod.yaml build
# Deploy with zero downtime (if configured)
docker compose -f compose.prod.yaml up -d --scale app=2
```

### Maintenance Mode
```bash
# Enable maintenance mode
docker exec dockerized_laravel_prod-workspace php artisan down
# Disable maintenance mode
docker exec dockerized_laravel_prod-workspace php artisan up
```

### Backup Commands
```bash
# Backup database
docker exec dockerized_laravel_prod-mysql mysqldump -u root -p4545 docker_test_db > backup_$(date +%Y%m%d).sql
# Backup storage directory
docker cp dockerized_laravel_prod-workspace:/var/www/html/storage ./storage_backup_$(date +%Y%m%d)
```

Note: Replace container names and credentials as needed according to your configuration.
