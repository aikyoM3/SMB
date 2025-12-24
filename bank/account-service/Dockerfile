# Multi-stage build for account-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Copy account-service pom.xml and source code
COPY account-service/pom.xml /app/account-service/pom.xml
COPY account-service/src /app/account-service/src

# Build only account-service
WORKDIR /app/account-service
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/account-service/target/account-service-0.0.4.jar account-service.jar

ENTRYPOINT ["java", "-jar", "account-service.jar"]
