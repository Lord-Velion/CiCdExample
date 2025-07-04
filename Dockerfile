# Многостадийная сборка с явным указанием путей
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Правильные переменные для этого образа
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Проверка окружения (можно удалить после теста)
RUN echo "JAVA_HOME=$JAVA_HOME" && \
    java -version && \
    mvn --version

WORKDIR /app
COPY pom.xml .
COPY src src

# Собираем проект (кешируя зависимости)
RUN mvn dependency:go-offline
RUN mvn clean package

# Финальный образ
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/CiCdExample-1.0-SNAPSHOT.jar ./app.jar
CMD ["java", "-jar", "app.jar"]