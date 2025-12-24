# Bank Management Application - Docker Setup

## Overview

This project contains a microservices-based bank management application with 6 services, all containerized with Docker using multi-stage builds.

## Services

- **account-service** - Manages bank accounts with CQRS and Event Sourcing
- **customer-service** - Manages customer information
- **authentication-service** - Handles user authentication and authorization
- **gateway-service** - API Gateway for routing requests
- **discovery-service** - Eureka Server for service discovery
- **notification-service** - Handles email notifications

## Prerequisites

- Docker and Docker Compose installed
- At least 8GB of available RAM
- Ports 3307-3309, 8024, 8124, 8761, 8884-8888, 8089 should be available

## Launch Instructions

### Quick Start

1. **Navigate to the bank directory:**

   ```bash
   cd bank
   ```

2. **Build and start all services:**

   ```bash
   docker-compose up --build
   ```

   This will:

   - Build all microservices using multi-stage Docker builds (Maven builds JARs inside Docker)
   - Start Axon Server first
   - Start MySQL databases (customer, account, auth)
   - Start all microservices in the correct order
   - Start Locust for load testing

3. **Run in detached mode (background):**

   ```bash
   docker-compose up --build -d
   ```

4. **View logs:**

   ```bash
   # All services
   docker-compose logs -f

   # Specific service
   docker-compose logs -f account-service
   ```

5. **Stop all services:**

   ```bash
   docker-compose down
   ```

6. **Stop and remove volumes (clean slate):**
   ```bash
   docker-compose down -v
   ```

## Service URLs

Once all services are running, you can access:

- **Eureka Discovery Service:** http://localhost:8761
- **API Gateway:** http://localhost:8888
- **Account Service:** http://localhost:8884
- **Customer Service:** http://localhost:8886
- **Authentication Service:** http://localhost:8885
- **Notification Service:** http://localhost:8887
- **Axon Server Console:** http://localhost:8024
- **Locust Load Testing UI:** http://localhost:8089

## Load Testing

The Locust UI provides real-time load testing statistics including:

- **Median (50th percentile)** response times
- **95th percentile** response times
- **99th percentile** response times
- Average, Min, Max response times
- Request rate and failure rate

Access the Locust UI at http://localhost:8089 to start load testing.

## Docker Build Details

All services use **multi-stage Docker builds**:

1. **Build Stage:** Uses `maven:3.9-eclipse-temurin-21` to compile and package the JAR
2. **Runtime Stage:** Uses `eclipse-temurin:21-jre` (lightweight) to run the application

This approach:

- ✅ No need to build JARs manually before Docker build
- ✅ Smaller final images (only JRE, not full JDK)
- ✅ Faster builds with Docker layer caching
- ✅ Each service builds independently

## Troubleshooting

### Services won't start

- Check if required ports are available
- Ensure Docker has enough resources allocated
- Check logs: `docker-compose logs <service-name>`

### Build failures

- Ensure you're in the `bank` directory when running `docker-compose`
- Try cleaning Docker cache: `docker system prune -a`
- Rebuild without cache: `docker-compose build --no-cache`

### Database connection issues

- Wait for databases to be fully initialized (check health status)
- Services have health checks and will wait for dependencies

## Service Startup Order

Services start in this order (enforced by dependencies):

1. Axon Server
2. MySQL Databases (customer, account, auth)
3. Discovery Service
4. Gateway Service
5. Notification Service
6. Authentication Service
7. Customer Service
8. Account Service
9. Locust

## Default Test User

The authentication service creates a default super admin user:

- **Username:** ADMINISTRATOR
- **Password:** 160220057a

⚠️ **Important:** Change this password in production!
