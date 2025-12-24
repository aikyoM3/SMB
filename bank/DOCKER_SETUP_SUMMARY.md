# Docker Setup Summary

## What Was Done

### 1. ✅ Updated docker-compose.yml
- Added MySQL databases for all services (customer, account, authentication)
- Added Axon Server with proper configuration
- Added all microservices with proper dependencies and health checks
- Added Locust for load testing with web UI
- Configured proper networking and service discovery
- Added health checks for all services

### 2. ✅ Created Missing Dockerfile
- Created `authentication-service/Dockerfile` (was missing)

### 3. ✅ Created Locust Load Testing Setup
- Created `locustfile.py` with comprehensive test scenarios
- **Fixed the "Cannot get accounts - user_id is None" bug** by:
  - Extracting `user_id` directly from JWT token using PyJWT
  - Adding proper error handling and fallback mechanisms
  - Ensuring all methods check for token and user_id before proceeding
- Created `requirements-locust.txt` for Python dependencies

### 4. ✅ Database Initialization
- Created initialization scripts directory (`init-scripts/`)
- Added placeholder SQL files for future manual data insertion

### 5. ✅ Documentation
- Created `SETUP.md` with comprehensive setup and troubleshooting guide
- Created helper scripts for test user creation (`create-test-user.sh` and `.ps1`)

## Key Features

### Bug Fix: "Cannot get accounts - user_id is None"
The locustfile now:
1. **Extracts user_id from JWT token** directly using PyJWT library
2. **Validates token** before attempting any operations
3. **Handles missing user_id gracefully** with proper logging
4. **Falls back to alternative methods** when user_id is not available
5. **Checks for token existence** in all methods that require authentication

### Service Architecture
```
MySQL Databases → Axon Server → Discovery Service → Gateway → Services
                                                              ↓
                                                          Locust (Testing)
```

### Port Mappings
- **3307-3309**: MySQL databases
- **8024, 8124**: Axon Server
- **8761**: Eureka Discovery
- **8884-8888**: Microservices
- **8089**: Locust Web UI

## How to Use

### Start Everything
```bash
cd bank
mvn clean install  # Build all services
docker-compose up -d  # Start all services
```

### Access Locust UI
1. Open http://localhost:8089
2. Configure test parameters
3. Start load testing

### Create Test User
Before running Locust tests, create a test user:
- Username: `testuser`
- Password: `testpass123`

You can create this through the authentication service API or manually in the database.

## Files Created/Modified

### Created:
- `bank/docker-compose.yml` (completely rewritten)
- `bank/authentication-service/Dockerfile`
- `bank/locustfile.py`
- `bank/requirements-locust.txt`
- `bank/SETUP.md`
- `bank/DOCKER_SETUP_SUMMARY.md`
- `bank/create-test-user.sh`
- `bank/create-test-user.ps1`
- `bank/init-scripts/init-auth.sql`
- `bank/init-scripts/init-customer.sql`
- `bank/init-scripts/init-account.sql`

### Modified:
- None (all new files)

## Next Steps

1. **Build the services:**
   ```bash
   mvn clean install
   ```

2. **Start Docker Compose:**
   ```bash
   docker-compose up -d
   ```

3. **Create test user** (see SETUP.md for details)

4. **Access Locust UI** at http://localhost:8089

5. **Run load tests** and monitor results

## Troubleshooting

See `SETUP.md` for detailed troubleshooting guide. Common issues:
- Port conflicts: Change ports in docker-compose.yml
- Database connection: Check health with `docker-compose ps`
- Authentication errors: Ensure test user exists
- "user_id is None": Fixed in locustfile, but ensure user is created first

## Notes

- All services use the same JWT_SECRET: `AaZzBbCcYyDdXxEeWwFf`
- Databases persist data in Docker volumes
- Services start in dependency order automatically
- Health checks ensure services are ready before dependent services start

