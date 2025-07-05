FROM maven:3.9-amazoncorretto-17 AS build

COPY settings.xml /root/.m2/
ENV MAVEN_OPTS="-Dmaven.wagon.http.retryHandler.count=5 -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 -Dmaven.wagon.http.readTimeout=360000"

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn -B dependency:go-offline && \
    mvn -B clean package -DskipTests

FROM amazoncorretto:17
COPY --from=build /app/target/*-jar-with-dependencies.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]