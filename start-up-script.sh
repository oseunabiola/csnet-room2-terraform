#!/bin/bash
# Update and upgrade the system
sudo apt update -y
sudo apt upgrade -y


# Install Java 11 and other required tools
sudo apt install openjdk-11-jdk maven git -y


# Add tomcat user and group
sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat

# Download and extract Tomcat
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz
sudo tar -xvf apache-tomcat-9.0.98.tar.gz
sudo mv apache-tomcat-9.0.98 tomcat9
sudo rm -rf apache-tomcat-9.0.98.tar.gz

# Set permissions
sudo chown -R tomcat:tomcat /opt/tomcat9

sudo sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/manager/META-INF/context.xml
sudo sed -i.bak '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/ s/^/<!-- /; /0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat9/webapps/host-manager/META-INF/context.xml
sudo sed -i 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="8085" protocol="HTTP\/1.1"/' /opt/tomcat9/conf/server.xml
sudo sed -i.bak '/<\/tomcat-users>/i \
<role rolename="manager-gui"/> \
<role rolename="admin-gui"/> \
<role rolename="manager-status"/> \
<user username="admin" password="admin@123" roles="manager-gui,admin-gui,manager-status,manager-script"/> \
' /opt/tomcat9/conf/tomcat-users.xml

# Create a systemd service file for Tomcat
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
User=tomcat
Group=tomcat
Type=forking
ExecStart=/opt/tomcat9/bin/startup.sh
ExecStop=/opt/tomcat9/bin/shutdown.sh
Restart=on-failure
[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/tomcat.service


# Reload systemd daemon and start Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat


git clone https://github.com/chawler-solutions-NeT/petadoption-springboot.git
cd petadoption-springboot
mvn compile package -Dcheckstyle.skip
sudo cp target/spring-petclinic-2.4.2.war /opt/tomcat9/webapps/
sudo nohup java -jar /opt/tomcat9/webapps/spring-petclinic-2.4.2.war &