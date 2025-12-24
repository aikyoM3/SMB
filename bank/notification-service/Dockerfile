# Multi-stage build for notification-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Install parent POM to local repository
RUN mvn install -N -DskipTests

# Copy notification-service pom.xml and source code
COPY notification-service/pom.xml /app/notification-service/pom.xml
COPY notification-service/src /app/notification-service/src

# Build only notification-service
WORKDIR /app/notification-service
RUN mvn clean package -DskipTests

# Find and copy the JAR to a known location (exclude .original files)
RUN find target -name "notification-service-*.jar" ! -name "*.original" -exec cp {} /app/notification-service.jar \;

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/notification-service.jar notification-service.jar

ENTRYPOINT ["java", "-jar", "notification-service.jar"]
