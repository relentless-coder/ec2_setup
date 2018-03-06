#!/bin/bash

echo "
|------------------------------------|
|------------------------------------|
|                                    |
|Welcome to ec2 setup!!! Let's begin |
|                                    |
|------------------------------------|
|------------------------------------|
"

echo "
/-----------------------------

Do you want to install nodejs?

-----------------------------/"
select yn in "Yes" "No"; do
      case $yn in
        Yes ) echo "Enter the version number, eg; 8, 9"
            read version
            curl -sL https://deb.nodesource.com/setup_$version.x | sudo -E bash - && sudo apt-get install -y nodejs && echo "Node version installed is $(node -v)"; break;;
                No ) break;;
      esac
done

echo "
/-----------------------------

Do you want to install mongodb?

-----------------------------/"

select yn in "Yes" "No"; do
      case $yn in
        Yes ) sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list && sudo apt-get update && sudo apt-get install -y mongodb-org && sudo service mongod start; break;;
        No ) break;;
      esac
done

echo "
/-----------------------------

Do you want to install angular-cli?

-----------------------------/"

select yn in "Yes" "No"; do
      case $yn in
        Yes ) sudo npm install -g @angular/cli; break;;
        No ) break;;
      esac
    done

echo "

/-----------------------------

Do you want to install Code-deploy agent?

-----------------------------/"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) echo 'Your bucket-name'
          read bucket
      sudo apt-get install ruby && sudo apt-get install wget && cd $HOME && wget https://$bucket.s3.amazonaws.com/latest/install && sudo chmod +x ./install && sudo ./install auto && sudo service codedeploy-agent start; break;;
    No ) break;;
  esac
done

echo "
/-----------------------------
Do you want to install yarn?
-----------------------------/"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt-get update && sudo apt-get install yarn && echo "Node version installed is $(yarn -v)"; break;;
    No ) break;;
  esac
done

echo "
/-----------------------------
Do you want to install nginx?
-----------------------------/"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) sudo apt-get install nginx && sudo service nginx start;  break;;
    No ) break;;
  esac
done

echo "
/-----------------------------
Do you want to install redis?
-----------------------------/"

select yn in "Yes" "No"; do
  case $yn in
    Yes ) sudo apt-get install build-essential tcl
      cd /tmp
      curl -O http://download.redis.io/redis-stable.tar.gz
      tar xzvf redis-stable.tar.gz
      cd redis-stable
      sudo make
      sudo make test
      sudo make install
      sudo mkdir /etc/redis
      sudo cp /tmp/redis-stable/redis.conf /etc/redis
      sed -i "s/\bsupervised no/supervised systemd/" "/etc/redis/redis.conf"
      sudo cat ./redis.systemd.txt >> /etc/systemd/system/redis.service
      sudo systemctl start redis && sudo systemctl enable redis;  break;;
    No ) break;;
  esac
done
