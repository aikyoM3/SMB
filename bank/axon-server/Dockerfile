# Dockerfile for Axon Server using axonserver.jar
FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Copy Axon Server jar and properties file
# Build context is set to parent directory in docker-compose.yml
COPY AxonServer-2025.2.0/axonserver.jar /app/axonserver.jar
COPY AxonServer-2025.2.0/axonserver.properties /app/axonserver.properties

# Create data directory
RUN mkdir -p /app/data

# Expose ports
# 8024 - HTTP port
# 8124 - gRPC port
EXPOSE 8024 8124

# Run Axon Server
ENTRYPOINT ["java", "-jar", "axonserver.jar"]

