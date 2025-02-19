#!/bin/bash
# Update and upgrade the system
sudo apt update -y
sudo apt upgrade -y

# Install NGINX
sudo apt install nginx -y

cd /var/www/html

sudo mkdir group2-website
cd group2-website

# Create a static webpage
echo "<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>CS Net | Group 2 website</title>
</head>
<body>
    <h1>Welcome</h1>
    <p>Group 2 webpage</p>
</body>
</html>
" | sudo tee /var/www/html/group2-website/index.html
