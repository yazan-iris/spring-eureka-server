FROM adoptopenjdk/openjdk15:ubi as builder
EXPOSE 8085
MAINTAINER iris.edu
RUN mkdir /opt/eureka
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

COPY --from=builder dependencies/ /dependencies
COPY --from=builder snapshot-dependencies/ /snapshot-dependencies
COPY --from=builder spring-boot-loader/ /spring-boot-loader
COPY --from=builder application/ /application
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]