Usage
To start everything:

```
cd bank
docker-compose up --build
```

Access Locust UI at http://localhost:8089 to view real-time load testing statistics with percentile graphs showing median, 50th, 95th, and 99th percentiles.
All services will start in the correct order, with Axon Server starting first, followed by databases, then all microservices, and finally Locust for load testing.
