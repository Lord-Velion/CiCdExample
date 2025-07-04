# Используем образ с Java 21
FROM eclipse-temurin:21-jdk-jammy

# Фиксим проблему с ключами репозиториев
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C && \
    echo "deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://security.ubuntu.com/ubuntu jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

# Устанавливаем Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN mvn clean package

CMD ["java", "-jar", "target/CiCdExample-1.0-SNAPSHOT.jar"]