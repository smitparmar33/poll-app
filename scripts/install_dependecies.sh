#!/bin/bash
sudo apt update
sudo apt -y upgrade

# Destination folder
cd /home/ubuntu
# AWS CLI needed to get parameters
sudo apt install -y awscli

# Installing NGINX, our reverse buffering proxy
# ------------------------------------------------------------------------------------
# Used for all Python/Ruby based web frameworks. This is due to buffering attacks.
# If a slow client starts downloading some content (even a single 1k HTML file), then
# the thread is blocked. When the thread is blocked, other requests will not be
# processed and will essentially be stuck. Even if it's unintentional, slow clients can
# kill your server. Thus, we have a buffering proxy.

# Note: if you're handling websockets, long polling, Comment, or other fancy stuff
# (e.g. using an ASGI framework), then NGINX may not be needed anymore. In that case,
# your web server doesn't need to serve on port 5000. It can now be running on port 80.
# When I mean the web server running on ports, visit start_server and change 5000 to 80
# and delete this section about NGINX.

# Even if you are using some async stuff, you can still use NGINX, just not the
# buffering. NGINX still allows you to make configurations that ALB doesn't let you,
# but NGINX doesn't matter as much anymore.

# Visit here for the source of this async explanation:
# https://docs.gunicorn.org/en/stable/deploy.html

sudo apt install -y nginx
sudo touch /etc/nginx/sites-enabled/project.conf

# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# CHANGE THE DOMAIN HERE!!!!!!!
# Change it below

# sudo cat <<EOT > /etc/nginx/sites-enabled/project.conf
# server {
#   set \$my_host \$host;
#   if (\$host ~ "\d+\.\d+\.\d+\.\d+") {
#       set \$my_host "donate-anything.org";
#   }

#   client_max_body_size 2G;
#   server_name donate-anything.org www.donate-anything.org;

#   keepalive_timeout 5;

#   location / {
#     proxy_pass http://127.0.0.1:5000;
#     proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#     proxy_set_header X-Forwarded-Proto \$scheme;
#     proxy_set_header Host \$my_host;
#     # we don't want nginx trying to do something clever with
#     # redirects, we set the Host: header above already.
#     proxy_redirect off;

#     ## The following is only needed for async frameworks:
#     ## NGINX example https://www.nginx.com/blog/websocket-nginx/
#     ## To turn off buffering, you only need to add `proxy_buffering off;`
#     # proxy_set_header Upgrade \$http_upgrade;
#     # proxy_set_header Connection 'upgrade';
#     ## 25 minutes of no data closes connection
#     # proxy_read_timeout 1500s;
#   }
# }
# EOT
# sudo service nginx restart
# ------------------------------------------------------------------------------------

# Installing Python and Preparing My Webserver
# ------------------------------------------------------------------------------------
# Since I needed Python 3.8, I manually installed it since my AMI was
# Ubuntu 20.04 LTS which only has Python 3.8 and below.
# Note, just doing `python` does not work anymore; you can only do python2
# and python3 commands

sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt install -y python3.8 python3.8-dev python3.8-venv
python3.8 -m ensurepip --default-pip --user

# My dependencies
sudo apt install -y build-essential libpq-dev gettext
# We're going to create a virtual environment to not screw up default packages
python3.8 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements/production.txt
# ------------------------------------------------------------------------------------

# BTW, I highly recommend IPython installed on local + production
# I didn't add it here since the tutorial's not about that, but super useful
# when identifying bugs with production data.