#!/bin/bash

set -e  # Exit script on any error

rm -rf apache-tomcat-8.5.96 apache-tomcat-8.5.96.tar.gz java-tomcat-maven-example/

# Check and install Java
if ! command -v  java &>/dev/null; then
    echo "Installing Java."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
else
    echo "Java already installed..."
fi

# Check and install Maven
if ! command -v mvn &>/dev/null; then
    echo "installing maven..."
    sudo apt update
    sudo apt install -y maven
else
    echo "Maven aready installed."
fi

# Check and install Git
if ! command -v git &>/dev/null; then
    echo "Installing git"
    sudo apt update
    sudo apt install -y git
else
    echo "Git already installed..."
fi

# Check if Tomcat is already installed
if systemctl list-units --type=service | grep -q tomcat; then
    echo "⚠️  Tomcat service found. Removing existing Tomcat installation..."

    sudo systemctl stop tomcat || true
    sudo systemctl disable tomcat || true
    sudo rm -rf /etc/systemd/system/tomcat.service
    sudo rm -rf /home/ubuntu/apache-tomcat-8.5.96
    sudo rm -rf /home/ubuntu/apache-tomcat-8.5.96.tar.gz
    sudo systemctl daemon-reload
fi

echo " Downloading and installing Tomcat..."

pwd

cd /home/ubuntu

# Clone the Maven webapp
git clone https://github.com/daticahealth/java-tomcat-maven-example.git

# Download and extract Tomcat
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz
tar -xvf apache-tomcat-8.5.96.tar.gz

# Replace tomcat-users.xml
sudo rm -f /home/ubuntu/apache-tomcat-8.5.96/conf/tomcat-users.xml
sudo cp /home/ubuntu/tomcat-users.xml /home/ubuntu/apache-tomcat-8.5.96/conf/

# Replace Tomcat systemd service file
sudo cp /home/ubuntu/tomcat.service /etc/systemd/system/tomcat.service

# Start and enable Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

echo "Tomcat deployed and running successfully!"

sh /home/ubuntu/java-deployment.sh

