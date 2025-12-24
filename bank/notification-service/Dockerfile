# Multi-stage build for notification-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Copy notification-service pom.xml and source code
COPY notification-service/pom.xml /app/notification-service/pom.xml
COPY notification-service/src /app/notification-service/src

# Build only notification-service
WORKDIR /app/notification-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/notification-service/target/notification-service-0.0.1.jar notification-service.jar

ENTRYPOINT ["java", "-jar", "notification-service.jar"]
