# Многостадийная сборка
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Явно устанавливаем JAVA_HOME
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app
COPY . .
RUN mvn clean package

FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/CiCdExample-1.0-SNAPSHOT.jar ./app.jar
CMD ["java", "-jar", "app.jar"]