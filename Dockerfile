FROM maven:3.9-amazoncorretto-17 AS build

# Копируем настройки Maven (если используются)
COPY settings.xml /root/.m2/

# Настройки сети для Maven
ENV MAVEN_OPTS="-Dmaven.wagon.http.retryHandler.count=3 -Dmaven.wagon.httpconnectionManager.ttlSeconds=25 -Dmaven.wagon.http.readTimeout=300000"

WORKDIR /app
COPY pom.xml .

# Шаг 1: Проверка POM
RUN mvn -B help:effective-pom

# Шаг 2: Загрузка зависимостей
RUN mvn -B dependency:resolve

# Шаг 3: Копирование кода и сборка
COPY src ./src
RUN mvn -B clean package -DskipTests

# Финальный образ
FROM amazoncorretto:17
COPY --from=build /app/target/*-jar-with-dependencies.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]