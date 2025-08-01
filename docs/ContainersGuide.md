# Docker Containers Guide

This document details the purpose and configuration of each container in our Laravel Docker setup.

## Development Environment Containers

### 1. dockerized_laravel_dev-apache
**Purpose**: Web Server
- Handles HTTP requests and serves web content
- Based on Apache 2.4 with mod_proxy_fcgi
- Configured with:
  - mod_rewrite for Laravel routing
  - mod_proxy_fcgi for PHP-FPM communication
  - Virtual host for `laravel12-docker.practice.test`
  - ProxyPassMatch configuration for PHP requests
- Exposes port 80 for web access
- Efficiently forwards PHP requests to PHP-FPM container

### 2. dockerized_laravel_dev-php-fpm
**Purpose**: PHP Process Manager
- Runs PHP 8.3 with PHP-FPM
- Listens on port 9000
- Custom php.ini configuration:
  - Development-oriented settings
  - Error display enabled
  - Increased memory limits
  - Session and upload configurations
- Contains essential PHP extensions:
  - PDO, MySQL, Redis
  - GD for image processing
  - ZIP for Composer
  - Xdebug for debugging
- Development configurations:
  - Display errors enabled
  - Maximum error reporting
  - Optimized for development
- Processes PHP requests from Apache
- Configured for optimal development workflow

### 3. dockerized_laravel_dev-mysql
**Purpose**: Database Server
- MySQL 8.0 database server
- Key configurations:
  - Runs on port 3307 (avoiding XAMPP conflicts)
  - Uses credentials from `.env`
  - Persistent storage in named volume
- Features:
  - Healthcheck enabled
  - Automatic database creation
  - Direct access for development tools
- Data persisted in `dockerized_laravel_dev-mysql-data`

### 4. dockerized_laravel_dev-redis
**Purpose**: Cache & Queue Server
- Redis Alpine for minimal footprint
- Used for:
  - Laravel cache storage
  - Session handling
  - Queue management
  - Real-time events
- Internal port 6379
- No external port exposed for security
- Healthcheck enabled

### 5. dockerized_laravel_dev-workspace
**Purpose**: Development Command Center
- Main development workspace containing:
  - PHP 8.3 CLI
  - Composer for dependencies
  - Node.js 22.0 and NPM
  - Git and common dev tools
- Features:
  - Exposes port 5173 for Vite
  - Runs with proper user permissions
  - Shares application volume mount
- Common commands run here:
  - `composer install/update`
  - `php artisan` commands
  - `npm run dev/build`

## Production Environment Containers

### 1. dockerized_laravel_prod-apache
**Purpose**: Production Web Server
- Enhanced Apache configuration:
  - Strict security headers
  - Optimized performance settings
  - Disabled directory listing
  - Hidden server information
  - ModSecurity (optional)
- SSL/TLS ready (when configured)

### 2. dockerized_laravel_prod-php-fpm
**Purpose**: Production PHP Runtime
- Optimized PHP-FPM 8.3:
  - Custom production php.ini
  - OpCache configured for production
  - Error display disabled
  - Production error logging
  - No development extensions
  - Tuned FPM process management
  - Optimized pool configuration
- Security focused:
  - Minimal PHP modules
  - Restricted file permissions
  - Secure PHP settings
  - Production-grade error handling
  - Controlled file access permissions

### 3. dockerized_laravel_prod-mysql
**Purpose**: Production Database
- MySQL 8.0 production setup:
  - Port 3307 configuration
  - Optimized InnoDB settings
  - Proper connection limits
  - Regular backup scheduling
- Enhanced security:
  - Restricted network access
  - Secure user permissions
  - SSL/TLS enabled connections

### 4. dockerized_laravel_prod-redis
**Purpose**: Production Cache Server
- Production-grade Redis:
  - AOF persistence enabled
  - Memory limits enforced
  - Maxmemory-policy configured
  - Connection restrictions
- High availability features:
  - Regular RDB snapshots
  - Monitored health checks

## Volume Management

### Development Volumes
| Volume Name | Purpose | Persistence |
|-------------|---------|-------------|
| `dockerized_laravel_dev-mysql-data` | MySQL data files | Permanent |
| `.:/var/www/html` | Application source | Development only |
| `./storage` | Laravel storage | Development only |

### Production Volumes
| Volume Name | Purpose | Backup Needed |
|-------------|---------|---------------|
| `dockerized_laravel_prod-mysql-data` | Database files | Yes |
| `dockerized_laravel_prod-storage` | App storage | Yes |
| `dockerized_laravel_prod-assets` | Compiled assets | No |

## Network Configuration

### Development Network (laravel-development)
- Internal container DNS resolution
- Isolated from host network
- Container-to-container communication
- Exposed ports:
  - 80 (Apache)
  - 3307 (MySQL)
  - 5173 (Vite)
  - 9000 (PHP-FPM)

### Production Network (laravel-production)
- Strict network isolation
- Internal service discovery
- Minimal port exposure
- Enhanced security rules
