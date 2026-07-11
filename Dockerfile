FROM eclipse-temurin:11-jdk AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ vprofile-project
RUN cd vprofile-project && mvn install

FROM tomcat:9.0-jdk11-temurin
LABEL "Project"="Vprofile"
LABEL "Author"="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Create a dedicated non-root user and give it ownership of Tomcat's directory
RUN groupadd -r tomcat && useradd -r -g tomcat -d /usr/local/tomcat -s /sbin/nologin tomcat \
    && chown -R tomcat:tomcat /usr/local/tomcat

USER tomcat

EXPOSE 8080
CMD ["catalina.sh", "run"]