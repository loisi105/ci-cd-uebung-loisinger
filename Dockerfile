# compile, test and package
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build

# Resolve dependencies first so this layer is cached until pom.xml changes
COPY pom.xml .
RUN mvn --batch-mode --no-transfer-progress dependency:go-offline

COPY src ./src
RUN mvn --batch-mode --no-transfer-progress package

# JRE and the JAR only
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /build/target/ci-cd-uebung-*.jar /app/app.jar

ENTRYPOINT ["java", "-cp", "/app/app.jar", "com.example.cicd.App"]
