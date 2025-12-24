# Docker Setup Guide for Bank Management Application

This guide explains how to set up and run the entire Bank Management Application using Docker Compose.

## Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- At least 8GB RAM available for Docker
- Ports 3307-3309, 8024, 8124, 8761, 8884-8888, 8089 should be available

## Quick Start

1. **Build the services:**
   ```bash
   cd bank
   mvn clean install
   ```

2. **Start all services with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

3. **Check service status:**
   ```bash
   docker-compose ps
   ```

4. **View logs:**
   ```bash
   # All services
   docker-compose logs -f
   
   # Specific service
   docker-compose logs -f account-service
   ```

## Services and Ports

| Service | Port | Description |
|---------|------|-------------|
| MySQL (Customer) | 3307 | Customer service database |
| MySQL (Account) | 3308 | Account service database |
| MySQL (Auth) | 3309 | Authentication service database |
| Axon Server | 8024, 8124 | Event store and gRPC port |
| Discovery Service | 8761 | Eureka service registry |
| Gateway Service | 8888 | API Gateway |
| Authentication Service | 8885 | User authentication |
| Customer Service | 8886 | Customer management |
| Account Service | 8884 | Account operations |
| Notification Service | 8887 | Email notifications |
| Locust | 8089 | Load testing UI |

## Service Startup Order

Services are configured with health checks and dependencies to start in the correct order:

1. MySQL databases (with health checks)
2. Axon Server
3. Discovery Service
4. Gateway Service
5. Notification Service
6. Authentication Service
7. Customer Service
8. Account Service
9. Locust

## Accessing Services

### Eureka Dashboard
- URL: http://localhost:8761
- View all registered services

### Locust Web UI
- URL: http://localhost:8089
- Start load tests from the web interface
- Default test user: `testuser` / `testpass123` (you may need to create this user first)

### API Gateway
- Base URL: http://localhost:8888
- Routes requests to appropriate services

### Axon Server Console
- URL: http://localhost:8024
- View events and aggregates

## Creating Test Users

Before running Locust tests, you need to create test users. You can do this through:

1. **Using the Authentication Service API:**
   ```bash
   # First, you may need admin access to create users
   # Or use the application's user registration endpoint if available
   ```

2. **Or manually insert into database:**
   ```bash
   docker exec -it mysql-auth mysql -uroot -proot db_user_new_devs_nours
   # Then insert user with BCrypt encoded password
   ```

## Running Locust Tests

1. **Access Locust UI:**
   - Open http://localhost:8089 in your browser

2. **Configure test:**
   - Number of users: Start with 10
   - Spawn rate: 2 users/second
   - Host: http://gateway-service:8888 (already configured)

3. **Start test:**
   - Click "Start swarming"
   - Monitor statistics in real-time

## Troubleshooting

### Services not starting

1. **Check logs:**
   ```bash
   docker-compose logs [service-name]
   ```

2. **Check health:**
   ```bash
   docker-compose ps
   ```

3. **Restart a service:**
   ```bash
   docker-compose restart [service-name]
   ```

### Database connection issues

- Ensure MySQL containers are healthy: `docker-compose ps`
- Check MySQL logs: `docker-compose logs mysql-customer`
- Verify network connectivity: `docker network inspect bank-network`

### "Cannot get accounts - user_id is None" error

This error occurs when:
1. User is not authenticated (no JWT token)
2. JWT token doesn't contain user_id claim
3. User_id extraction from token fails

**Solutions:**
- Ensure test user exists in authentication database
- Verify JWT_SECRET matches across all services
- Check that login endpoint returns valid JWT token
- The locustfile now extracts user_id directly from JWT token to prevent this issue

### Port conflicts

If ports are already in use:
- Change port mappings in `docker-compose.yml`
- Or stop conflicting services

## Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (clears databases)
docker-compose down -v
```

## Rebuilding Services

After code changes:

```bash
# Rebuild specific service
docker-compose build account-service

# Rebuild and restart
docker-compose up -d --build account-service

# Rebuild all
docker-compose build
docker-compose up -d
```

## Database Persistence

Databases use Docker volumes for persistence:
- `mysql-customer-data`
- `mysql-account-data`
- `mysql-auth-data`
- `axon-server-data`
- `axon-server-events`

Data persists across container restarts. To reset:
```bash
docker-compose down -v
docker-compose up -d
```

## Network Configuration

All services are on the `bank-network` bridge network, allowing them to communicate using service names as hostnames.

## Environment Variables

Key environment variables (can be overridden in docker-compose.yml):
- `JWT_SECRET`: Secret key for JWT tokens (default: AaZzBbCcYyDdXxEeWwFf)
- `MYSQL_USER`: MySQL username (default: root)
- `MYSQL_PWD`: MySQL password (default: root)
- `AXON_HOST`: Axon Server hostname (default: axon-server)
- `AXON_PORT`: Axon Server gRPC port (default: 8124)

## Next Steps

1. Create test users in the authentication service
2. Create test customers in the customer service
3. Create test accounts in the account service
4. Run Locust load tests
5. Monitor service health and performance

