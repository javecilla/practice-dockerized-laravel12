# Dockerized Laravel 12 Practice Project

This is my personal practice repository for learning and experimenting with Docker containerization of Laravel 12 applications. The project serves as a hands-on learning environment for mastering Docker, Laravel, and modern development workflows.

## Project Overview

This repository contains a Docker-based development and production environment for Laravel 12, configured with:

- PHP 8.3 with PHP-FPM
- Apache web server
- MySQL 8.0 database
- Redis for caching
- Node.js 22.0 for frontend assets

## Learning Objectives

This project helps me practice:

- Docker containerization
- Laravel application architecture
- Development vs. Production environments
- Container orchestration
- Database management
- Caching strategies
- Modern PHP practices

## Project Structure

```
dockerized-laravel/
├── app/                 # Laravel application code
├── docker/             # Docker configuration files
│   ├── development/    # Development environment
│   └── production/     # Production environment
├── docs/               # Documentation
│   ├── ContainersGuide.md
│   ├── DockerCommands.md
│   └── RunEnvironment.md
└── compose.*.yaml      # Docker Compose configurations
```

## Documentation

Detailed documentation is available in the `docs` directory:

- [Container Guide](docs/ContainersGuide.md) - Details about each container
- [Docker Commands](docs/DockerCommands.md) - Common Docker commands reference
- [Environment Guide](docs/RunEnvironment.md) - Setup and running instructions

## Quick Start

1. Clone this repository
2. Copy `.env.example` to `.env`
3. Configure host entry:
   ```
   127.0.0.1 laravel12-docker.practice.test
   ```
4. Start the development environment:
   ```bash
   docker compose -f compose.dev.yaml up -d
   ```
5. Install dependencies:
   ```bash
   docker exec dockerized_laravel_dev-workspace composer install
   docker exec dockerized_laravel_dev-workspace php artisan key:generate
   ```

## Features

- Separate development and production configurations
- PHP-FPM for improved performance
- Hot-reloading for development
- Persistent data storage
- Automated permission handling
- Easy-to-use workspace container

## Port Configuration

- Apache: 80
- MySQL: 3307 (adjusted to avoid XAMPP conflicts)
- Redis: 6379 (internal)
- PHP-FPM: 9000 (internal)
- Vite Dev Server: 5173

## Notes

This is a practice project and is continuously evolving as I learn and experiment with:

- Docker best practices
- Container optimization
- Security configurations
- Performance tuning
- Development workflows

Feel free to explore and learn from this repository, but keep in mind it's primarily for personal learning and experimentation.

## Disclaimer

This is a practice project and may contain experimental configurations. While it works for learning purposes, additional security and optimization measures would be needed for production use.

## License

This project is open-sourced software licensed under the MIT license.
