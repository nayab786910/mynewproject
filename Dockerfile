FROM openjdk:11
EXPOSE 8080
ADD target/myspringbootapp-0.0.1-SNAPSHOT.jar myspringbootapp.jar
ENTRYPOINT ["java","-jar","/myspringbootapp.jar"]
