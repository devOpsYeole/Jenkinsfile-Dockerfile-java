FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/java-app.jar app.jar

CMD ["java", "-jar", "app.jar"]
