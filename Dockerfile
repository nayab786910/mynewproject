FROM openjdk:11
EXPOSE 8083
ADD target/myspringbootapp-0.0.1-SNAPSHOT.jar myspringbootapp.jar
ENTRYPOINT ["java","-jar","/myspringbootapp.jar"]
