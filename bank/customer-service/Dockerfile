# Multi-stage build for customer-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Copy customer-service pom.xml and source code
COPY customer-service/pom.xml /app/customer-service/pom.xml
COPY customer-service/src /app/customer-service/src

# Build only customer-service
WORKDIR /app/customer-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/customer-service/target/customer-service-0.0.1.jar customer-service.jar

ENTRYPOINT ["java", "-jar", "customer-service.jar"]
