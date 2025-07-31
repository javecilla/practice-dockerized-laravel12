# Laravel Docker Environment Guide

This guide explains how to set up and run your Laravel application using Docker. The environment is configured for both development and production use.

## Quick Start

1. Clone the repository
2. Copy `.env.example` to `.env`
3. Run `docker compose -f compose.dev.yaml up -d --build`
4. Visit http://laravel12-docker.practice.test

## Prerequisites

### Required Software
- Docker Desktop installed and running
- Git for version control

### System Requirements
- Available Ports:
  - `80` - Web Server (Apache)
  - `3307` - Database (MySQL) - Using 3307 to avoid conflicts with XAMPP
  - `5173` - Frontend Dev Server (Vite)
  - `9000` - PHP-FPM

### Host Configuration
1. Open your hosts file:
   - Windows: `C:\Windows\System32\drivers\etc\hosts`
   - Linux/Mac: `/etc/hosts`

2. Add this line:
   ```
   127.0.0.1 laravel12-docker.practice.test
   ```

## Initial Setup

### Environment Configuration
1. Create your `.env` file:
   ```bash
   cp .env.example .env
   ```

2. Configure your environment variables:
   ```properties
   # Database Configuration
   DB_CONNECTION=mysql
   DB_HOST=mysql
   DB_PORT=3307
   DB_DATABASE=docker_test_db
   DB_USERNAME=root
   DB_PASSWORD=4545

   # Redis Configuration
   REDIS_HOST=redis
   REDIS_PASSWORD=null
   REDIS_PORT=6379

   # Application URL
   APP_URL=http://laravel12-docker.practice.test
   ```

## Development Environment

### Starting Development Environment

1. Build and start all containers:
   ```bash
   docker compose -f compose.dev.yaml up -d --build
   ```

2. Container Configuration:
   | Container Name | Purpose | Port | Notes |
   |---------------|---------|------|-------|
   | `dockerized_laravel_dev-apache` | Web Server | 80 | Apache with PHP module |
   | `dockerized_laravel_dev-php-fpm` | PHP Runtime | 9000 | PHP-FPM process manager |
   | `dockerized_laravel_dev-mysql` | Database | 3307 | MySQL 8.0 |
   | `dockerized_laravel_dev-redis` | Cache Server | 6379 | Redis Alpine |
   | `dockerized_laravel_dev-workspace` | Dev Tools & Commands | 5173 | For running artisan, composer, npm |

### First-Time Application Setup

Once containers are running, initialize your Laravel application:

1. Install Composer dependencies:
   ```bash
   docker exec dockerized_laravel_dev-workspace composer install
   ```

2. Set up Laravel:
   ```bash
   # Generate application key
   docker exec dockerized_laravel_dev-workspace php artisan key:generate

   # Run database migrations
   docker exec dockerized_laravel_dev-workspace php artisan migrate

   # Clear configuration cache
   docker exec dockerized_laravel_dev-workspace php artisan config:clear
   ```

### Development Environment Features

Key features available in development:

- Live Code Updates
  - Direct volume mounting for immediate code changes
  - No container rebuilds needed for PHP code changes
  - Hot reloading for frontend development (Vite)

- Development Tools
  - PHP 8.3 with common extensions
  - Node.js and NPM for frontend development
  - Composer for PHP dependencies
  - Xdebug for debugging
  - Full access to Artisan CLI

- Data Persistence
  - MySQL data persists in named volumes
  - Automatic storage permission handling
  - Persistent Redis cache

## Production Environment

### Launching Production

1. Build and start production containers:
   ```bash
   docker compose -f compose.prod.yaml up -d --build
   ```

2. Production Container Stack:
   | Container Name | Purpose | Configuration |
   |---------------|---------|---------------|
   | `dockerized_laravel_prod-apache` | Web Server | Apache with mod_rewrite, security headers |
   | `dockerized_laravel_prod-php-fpm` | PHP Runtime | PHP-FPM with OpCache |
   | `dockerized_laravel_prod-mysql` | Database | MySQL 8.0 with optimized settings |
   | `dockerized_laravel_prod-redis` | Cache Server | Redis with persistence |

### Production Environment Features

Production optimizations include:

- Performance
  - PHP OpCache enabled and configured
  - Apache with optimized settings
  - Redis for session and cache storage
  - MySQL 8.0 with performance configuration

- Security
  - Production-level error reporting
  - Debug mode disabled
  - Secure headers configured
  - Restricted file permissions

- Data Management
  - Named volumes for persistence:
    ```
    dockerized_laravel_prod-mysql-data  # Database files
    dockerized_laravel_prod-storage     # Laravel storage
    dockerized_laravel_prod-assets      # Compiled assets
    ```

## Common Commands

### Container Management
```bash
# Start development environment
docker compose -f compose.dev.yaml up -d

# View running containers
docker ps

# View container logs
docker logs dockerized_laravel_dev-php-fpm     # PHP-FPM logs
docker logs dockerized_laravel_dev-apache      # Apache logs
docker logs dockerized_laravel_dev-mysql       # MySQL logs

# Access workspace shell
docker exec -it dockerized_laravel_dev-workspace bash
```

### Laravel Artisan Commands
```bash
# Database commands
docker exec dockerized_laravel_dev-workspace php artisan migrate        # Run migrations
docker exec dockerized_laravel_dev-workspace php artisan db:seed       # Seed database
docker exec dockerized_laravel_dev-workspace php artisan migrate:fresh # Reset database

# Cache commands
docker exec dockerized_laravel_dev-workspace php artisan cache:clear  # Clear cache
docker exec dockerized_laravel_dev-workspace php artisan config:clear # Clear config
docker exec dockerized_laravel_dev-workspace php artisan view:clear   # Clear views

# Development helpers
docker exec dockerized_laravel_dev-workspace php artisan route:list   # List routes
docker exec dockerized_laravel_dev-workspace php artisan make:model   # Create model
```

### Environment Management
```bash
# Development Environment
docker compose -f compose.dev.yaml up -d     # Start
docker compose -f compose.dev.yaml down      # Stop
docker compose -f compose.dev.yaml down -v   # Stop and remove volumes

# Production Environment
docker compose -f compose.prod.yaml up -d    # Start
docker compose -f compose.prod.yaml down     # Stop
```

## 🌐 Accessing Your Application

| Environment | URL | Notes |
|------------|-----|-------|
| Development | http://laravel12-docker.practice.test | Hot reloading enabled |
| Production | http://laravel12-docker.practice.test | Optimized for performance |

## Troubleshooting

### Common Issues and Solutions

1. **Permission Issues**
   - Issue: Storage/cache write errors
   - Solution: Run `docker exec dockerized_laravel_dev-workspace chown -R www-data:www-data storage bootstrap/cache`

2. **Container Won't Start**
   - Check port conflicts: `netstat -ano | findstr "80 3307 6379 9000 5173"`
   - View container logs: `docker logs <container-name>`
   - Ensure no other MySQL instances (like XAMPP) are using port 3307

3. **Database Connection Issues**
   - Verify DB_PORT is set to 3307 in .env file
   - Check MySQL container health: `docker ps`
   - View MySQL logs: `docker logs dockerized_laravel_dev-mysql`

4. **PHP-FPM Issues**
   - Check PHP-FPM logs: `docker logs dockerized_laravel_dev-php-fpm`
   - Verify PHP-FPM is listening on port 9000
   - Ensure Apache is properly configured to work with PHP-FPM