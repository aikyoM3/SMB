# Multi-stage build for authentication-service
# Stage 1: Build the JAR
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy parent pom.xml first (for dependency resolution)
COPY pom.xml /app/pom.xml

# Install parent POM to local repository
RUN mvn install -N -DskipTests

# Copy authentication-service pom.xml and source code
COPY authentication-service/pom.xml /app/authentication-service/pom.xml
COPY authentication-service/src /app/authentication-service/src

# Build only authentication-service
WORKDIR /app/authentication-service
RUN mvn clean package -DskipTests

# Find and copy the JAR to a known location (exclude .original files)
RUN find target -name "authentication-service-*.jar" ! -name "*.original" -exec cp {} /app/authentication-service.jar \;

# Stage 2: Runtime
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/authentication-service.jar authentication-service.jar

ENTRYPOINT ["java", "-jar", "authentication-service.jar"]
