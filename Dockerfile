# Используем базовый образ с Java 21
FROM eclipse-temurin:21-jdk-jammy

# Устанавливаем Maven вручную
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исходный код
COPY . .

# Собираем проект
RUN mvn clean package

# Запускаем приложение
CMD ["java", "-jar", "target/CiCdExample-1.0-SNAPSHOT.jar"]