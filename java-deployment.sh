#!/bin/bash
set -o
set -x
# Show current directory
pwd 

# Navigate to project folder and build with Maven
cd /home/ubuntu/java-tomcat-maven-example && mvn clean install

# Stop Tomcat (if it's running)
sudo systemctl stop tomcat
sudo rm -rf /home/ubuntu/apache-tomcat-8.5.96/webapps/manager/META-INF/context.xml
sudo cp /home/ubuntu/context.xml /home/ubuntu/apache-tomcat-8.5.96/webapps/manager/META-INF/context.xml
sudo rm -rf  /home/ubuntu/apache-tomcat-8.5.96/webapps/java-tomcat-maven-example.war
sudo rm -rf  /home/ubuntu/apache-tomcat-8.5.96/webapps/java-tomcat-maven-example

# Deploy the WAR file to Tomcat's webapps folder
cp /home/ubuntu/java-tomcat-maven-example/target/*.war /home/ubuntu/apache-tomcat-8.5.96/webapps/

# Start Tomcat
sudo systemctl restart tomcat

# Show logs in real-time
tail -f /home/ubuntu/apache-tomcat-8.5.96/logs/catalina.out

