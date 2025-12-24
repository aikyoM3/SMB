# Multi-stage build for discovery-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Copy discovery-service pom.xml and source code
COPY discovery-service/pom.xml /app/discovery-service/pom.xml
COPY discovery-service/src /app/discovery-service/src

# Build only discovery-service
WORKDIR /app/discovery-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/discovery-service/target/discovery-service-0.0.1-SNAPSHOT.jar discovery-service.jar

ENTRYPOINT ["java", "-jar", "discovery-service.jar"]
