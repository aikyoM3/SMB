# Multi-stage build for gateway-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Install parent POM to local repository
RUN mvn install -N -DskipTests

# Copy gateway-service pom.xml and source code
COPY gateway-service/pom.xml /app/gateway-service/pom.xml
COPY gateway-service/src /app/gateway-service/src

# Build only gateway-service
WORKDIR /app/gateway-service
RUN mvn clean package -DskipTests

# Find and copy the JAR to a known location (exclude .original files)
RUN find target -name "gateway-service-*.jar" ! -name "*.original" -exec cp {} /app/gateway-service.jar \;

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/gateway-service.jar gateway-service.jar

ENTRYPOINT ["java", "-jar", "gateway-service.jar"]
