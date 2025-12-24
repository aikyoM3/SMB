# Multi-stage build for customer-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Install parent POM to local repository
RUN mvn install -N -DskipTests

# Copy customer-service pom.xml and source code
COPY customer-service/pom.xml /app/customer-service/pom.xml
COPY customer-service/src /app/customer-service/src

# Build only customer-service
WORKDIR /app/customer-service
RUN mvn clean package -DskipTests

# Find and copy the JAR to a known location (exclude .original files)
RUN find target -name "customer-service-*.jar" ! -name "*.original" -exec cp {} /app/customer-service.jar \;

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/customer-service.jar customer-service.jar

ENTRYPOINT ["java", "-jar", "customer-service.jar"]
