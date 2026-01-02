FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY target/java-app.jar app.jar

CMD ["java", "-jar", "app.jar"]
