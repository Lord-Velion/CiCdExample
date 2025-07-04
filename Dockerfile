# Используем облегченный образ только для сборки
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Отключаем предварительную проверку версий (которая вызывает ошибку)
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn clean package

# Финальный образ с JRE (без JDK)
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/CiCdExample-1.0-SNAPSHOT.jar ./app.jar

# Безопасные настройки для Java в контейнере
ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75"
CMD ["java", "-jar", "app.jar"]