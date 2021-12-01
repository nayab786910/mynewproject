FROM openjdk:11
EXPOSE 8083
ADD target/myspringbootapp.jar myspringbootapp.jar
ENTRYPOINT ["java","-jar","/myspringbootapp.jar"]
