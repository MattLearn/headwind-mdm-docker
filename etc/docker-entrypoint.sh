#!/bin/sh

# Start postgres
catalina.sh start
adb devices
service postgresql restart

# Create database if doesn't exist
if [ $HMDM_SQL_USER != 'hmdm' ]; then
    sudo -u postgres psql -c "CREATE USER $HMDM_SQL_USER WITH PASSWORD '$HMDM_SQL_PASS';"
fi

if [ $HMDM_SQL_BASE != 'hmdm' ]; then
    sudo -u postgres psql -c "CREATE DATABASE $HMDM_SQL_BASE WITH OWNER=$HMDM_SQL_USER;"
fi

if [ ! -f '/usr/local/tomcat/conf/Catalina/localhost//hmdm.xml' ]; then
    cd /home/hmdmr/hmdm-install/
    ./hmdm_install.sh
fi

catalina.sh stop
sleep 30
cd ..
catalina.sh run

