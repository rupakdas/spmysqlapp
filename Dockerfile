#Stage 1
# initialize build and set base image for first stage
FROM maven:3.8.3-openjdk-17 as build
# set working directory
WORKDIR /opt/demo
# copy just pom.xml
COPY pom.xml .
# go-offline using the pom.xml
RUN mvn dependency:go-offline
# copy your other files
COPY ./src ./src
# compile the source code and package it in a jar file
RUN mvn clean install -Dmaven.test.skip=true
#Stage 2
# set base image for second stage
FROM eclipse-temurin:17-jre-alpine
# set deployment directory
WORKDIR /opt/demo
# copy over the built artifact from the maven image
COPY --from=build /opt/demo/target/sp_mysql_demo.jar /opt/demo
# set environment file

EXPOSE 8080:8080

ENTRYPOINT ["java","-jar","/opt/demo/sp_mysql_demo.jar"]