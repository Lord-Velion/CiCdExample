FROM maven:3.9-amazoncorretto-17 AS build

# Настройки Maven
COPY settings.xml /root/.m2/settings.xml
ENV MAVEN_OPTS="-Dhttp.keepAlive=false -Dmaven.wagon.http.pool=false -Dmaven.wagon.httpconnectionManager.ttlSeconds=120"

# Рабочая директория
WORKDIR /app
COPY pom.xml .

# Скачивание зависимостей
RUN mvn dependency:purge-local-repository -DactTransitively=false -DreResolve=false && \
    mvn dependency:resolve-plugins dependency:resolve -B

# Сборка приложения
COPY src ./src
RUN mvn clean package -DskipTests -B

# Финальный образ
FROM amazoncorretto:17
COPY --from=build /app/target/*-jar-with-dependencies.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]