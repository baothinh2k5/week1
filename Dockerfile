
# Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
# Click nbfs://nbhost/SystemFileSystem/Templates/Other/Dockerfile to edit this template

# --- Stage 1: Build WAR with Maven (JDK 17) ---
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# copy pom trước để cache dependency
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# copy source và build
COPY src ./src
RUN mvn -q -DskipTests package

# --- Stage 2: Run on Tomcat 10 (Jakarta) ---
FROM tomcat:10.1-jdk17-temurin

# xoá webapp mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# copy WAR ra làm ROOT.war để chạy ở "/"
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
