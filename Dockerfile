FROM tomcat:latest

RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps

COPY /usr/local/tomcat/webapps/*.war /opt/tomcat/webapps

WORKDIR /opt/tomcat/webapps
