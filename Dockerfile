# Используем официальный образ Maven для сборки
FROM maven:3.9-amazoncorretto-17-al2023 AS build
WORKDIR /app
COPY pom.xml .
# Скачиваем зависимости (кешируем этот слой для ускорения сборки)
RUN mvn dependency:go-offline
COPY src ./src
# Собираем JAR
RUN mvn clean package -DskipTests

# Используем легковесный образ для запуска
FROM openjdk:17-jdk-slim
WORKDIR /app
# Копируем собранный JAR из предыдущего этапа
COPY --from=build /app/target/*.jar app.jar
# Указываем точку входа
ENTRYPOINT ["java", "-jar", "app.jar"]