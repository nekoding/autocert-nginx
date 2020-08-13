#!/usr/bin/env bash 

# COLOR SCHEME
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

echo "Auto sudomain ssl in Nginx webserver"
printf "=====================================\n\n"

# check domain input
if [ -z $1 ]
then
        echo -e "${RED}[✘] need domain input ${NC}"
        exit
fi

# check certbot
echo "~ Check certbot ...." && sleep 2
if ! command -v certbot &> /dev/null
then
        echo -e "${RED}[✘] Need install certbot${NC}"
        sudo apt install certbot python3-certbot-nginx
else
        echo -e "${GREEN}[✓] Certbot found${NC}"
fi

echo -e "~ Check nginx ....." && sleep 2

# check nginx
if ! command -v nginx &> /dev/null
then
        echo -e "${RED}[✘] Need install nginx${NC}"
        sudo apt install nginx
else
 echo -e "${GREEN}[✓] Nginx found${NC}"
fi

echo "${GREEN}Generate nginx config for${NC} $1" && sleep 3
sed "s/%DOMAIN_NAME%/$1/g" _default.txt > $1 && sudo mv $1 /etc/nginx/sites-available/$1
sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1

echo "${GREEN}Reload nginx configuration ....${NC}" && sleep 3
sudo nginx -t && sudo systemctl reload nginx

echo "${GREEN}Running certbot ....${NC}" && sleep 2
sudo certbot --nginx -d $1
sudo systemctl reload nginx

echo "${GREEN}done.${NC}"