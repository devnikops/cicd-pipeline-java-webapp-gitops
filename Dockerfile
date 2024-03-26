# Use a base image with Tomcat pre-installed
FROM tomcat:latest

# Copy the WAR file into the webapps directory of Tomcat
COPY *.war /opt/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080



