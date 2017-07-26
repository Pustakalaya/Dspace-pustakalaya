#!/bin/bash
# Purpose: install and setup dspace 
# Os: ubuntu 16.04
# Author: Manoj Gautam <manoj.gautam@olenepal.org>

# Ubuntu 16.04 by default use openjdk 1.8
sudo apt-get install default-jdk -y

# Create the dspace user
useradd -m dspace

# Add the dspace user to sudo group 
usermod -aG sudo dspace

# TODO: set the dspace user password from configuration file
# TODO: switch to dspace user and run this script

# Create /dspace/ directory for dspace
mkdir /dspace
# give ownership to dspace user

chown -R dspace:dspace /dspace/

####################################
#Downloading and installing dspace from github
####################################

########################################
# prerequities package installation
#########################################

# Install postgresql 9.5, ubuntu 16.04 LTS has 9.5 > versio of postgresql
apt-get install postgresql -y

# Install ant v1.9 ubuntu 16.04 LTS has version 1.9 in its repo
apt-get install ant -y

# Install maven v3.3.9 ubuntu 16.04 LTS has version v3.3.9 in its repo
apt-get install maven

#Install ImageMagick
wget https://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
cd ImageMagick-7.0.6
./configure
make
sudo make install
sudo ldconfig /usr/local/lib
cd

#TODO: install Ghostscript
sudo apt-get install ghostscript
sudo apt-get install imagemagick


##############################################################################
#This section defines the installation and configuration of tomcat web server
###############################################################################

# Install curl 
apt-get install curl

# Install wget
apt-get install wget

# Download the tomcat
#wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.13/bin/apache-tomcat-8.5.13.tar.gz
#wget https://fossies.org/linux/www/legacy/apache-tomcat-8.5.13.tar.gz
# Extract the tomcat
# Use tomcat 8.5.3
tar -xvzf apache-tomcat-8.5.13.tar.gz
# Remove the tar file
#rm -rf apache-tomcat-8.5.13.tar.gz 
# Create a directory for tomcat
mkdir /opt/tomcat
#pushd  /opt/tomcat/
# Move the source files of tomcat to tomcat directory.
cp -arv apache-tomcat-8.5.13/* /opt/tomcat/
# Delete the apache-tomcat source directory from the current directory.
rm -rf apache-tomcat-8.5.13/
# Move to tomcat directory
pushd  /opt/tomcat/
# add dspace user as a group to tomcat directory
chgrp -R dspace /opt/tomcat
# Grant read and execute to dspace user to tomcat conf directory
chmod -R g+r conf
chmod g+x conf
# Make the dspace user the owner of the webapps, work, temp, and logs directories:
chown -R dspace webapps/ work/ temp/ logs/
# Creating systemd services.
popd

echo "
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=dspace
Group=dspace
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/tomcat.service

# Configure the browsing capability in dspace for tomcat

# Reload the daemon to make sure the tomcat.service is in effect
systemctl daemon-reload
# Install tomcat service
systemctl start tomcat
# Start tomcat on reboot
systemctl enable tomcat
# Adjust the firewall for tomcat
ufw allow 8080
# Adjusting web management interface
#TODO: 
#TODO: configuration of config/server.xml file for optimization

#TODO: Tomcat username password setup for administrative dashboard
# vim /opt/tomcat/conf/tomcat-users.xml 
# Set the following value in tomcat-users.xml under <tomcat-users>
#  <user username="dspace" password="dspace" roles="manager-gui,admin-gui"/>
# TODO: all the 127.0.0.1 to access the administrative dashboard.
# sudo vim /opt/tomcat/webapps/host-manager/META-INF/context.xml

# Comment out the following block from context.xml file to allow localhost to 
# acess tomcat administrative dashboard as shown below.
# <Context antiResourceLocking="false" privileged="true" >
#  <!--<Valve className="org.apache.catalina.valves.RemoteAddrValve"
#         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />-->
#</Context>

# Restart the tomcat after making those changes
systemctl restart tomcat





###################################################
# This section describe the configuration of dspace
######################################################
# Deploy the build web application
# For each of the UI(Web appliction) define context 
# Dspace is composed of multiple web application.
# Define all the context in $TOMCAT_HOME/conf/Catalina/locahost directory
# In our case /opt/tomcat/conf/Catalina/localhost
# Define each context for each application.
# Such as xmlui.xml, jspu.xml, solr.xml, oai.xml, rdf.xml, rest.xml, sword.xml, swordv2.xml 
# Create the configuration file for each app
mkdir -p /opt/tomcat/conf/Catalina/localhost/
pushd /opt/tomcat/conf/Catalina/localhost/
# Create the required configuration file for dspace
touch {xmlui,jspui,solr,oai,rdf,rest,sword,swordv2}.xml
# Create the configuration file for xmlui
# This assume that your build dpsace directory lies in /dspace dir
# If this is somewhere else please modify docBase directory
# TODO: Need to remove hardcoded url such as, docBase and tomcat configuration directory

#################################
# Context path setup for xmlui
################################
echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/xmlui\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" > /opt/tomcat/conf/Catalina/localhost/xmlui.xml

#################################
# Context path setup for jspui
################################

echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/jspui\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" > /opt/tomcat/conf/Catalina/localhost/jspui.xml


######################################################
#DEFINE A CONTEXT PATH FOR DSpace Solr index: solr.xml
####################################################

echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/solr\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" > /opt/tomcat/conf/Catalina/localhost/solr.xml

###############################################
#Context path setup for oai.xml
#################################################
echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/oai\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" >  /opt/tomcat/conf/Catalina/localhost/oai.xml

###############################################
#Context path setup for rest.xml
#################################################
echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/rest\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" >  /opt/tomcat/conf/Catalina/localhost/rest.xml


###############################################
#Context path setup for rdf.xml
#################################################
echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/rdf\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" >  /opt/tomcat/conf/Catalina/localhost/rdf.xml


###############################################
#Context path setup for sord.xml
#################################################
echo "
<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/sword\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" >  /opt/tomcat/conf/Catalina/localhost/sword.xml

###############################################
#Context path setup for swordv2.xml
#################################################
echo "<?xml version='1.0'?>
<Context
    docBase=\"/dspace/webapps/swordv2\"
    reloadable=\"true\"
    cachingAllowed=\"false\"/>
" >  /opt/tomcat/conf/Catalina/localhost/swordv2.xml

# TODO: configure the context value suchas reloadable="true" and other settings as per your need 
# to suite your production environment.
# TODO: Change: for production set reloadable="false"
# TODO: Change: for production set cachingAllowed="false" to reduce runtime overhead

# Restart the tomcat after deploying the thing.
systemctl restart tomcat

####################################################################
# Create administrative password for dpace
# TODO: set the admin password in configuration file and add here
#####################################################################
# automate this command by givng the answer from configuration file
#TODO: /dspace/bin/dspace create-administrator
/dspace/bin/dspace create-administrator
# Restart the tomcat 
systemctl start tomcat

########################################################
# Email, cronjob and index preparation settings
######################################################
# TODO: see this note https://wiki.duraspace.org/display/DSDOC6x/Installing+DSpace#InstallingDSpace-InstallationInstructions
# TODO: follow the above link for production


#################################################
# Localization and internationalization setup
##################################################
# add your language in /src/dspace/config/local.cfg: file
# default.locale, e.g. default.locale = en
# webui.supported locales, e.g. webui.supported.locales = en, de



########Database setup###############
# modify pg.hba.conf file to
# change local   all     all    peer to
# change local   all     all    md5 to
# by being postgres user
createuser --username=postgres --no-superuser --pwprompt dspace
# create a dspace database
createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
# Login to the database as a superuser, and enable the pgcrypto extension on this database
psql --username=postgres dspace -c "CREATE EXTENSION pgcrypto;"


###########################################
# Front end tools dependencies installation
###########################################
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash 
source ~/.profile
nvm install 6.5.0 
nvm alias default 6.5.0
npm install -g bower
npm install -g grunt && npm install -g grunt-cli 

# Install some ruby dependencies
sudo apt-get install ruby-dev

# Import a key
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -

# Install ruby to compile sass
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Install sass 
sudo gem install sass -v 3.3.14

# Install compass
sudo gem install compass -v 1.0.1


#Quick Note: So these features needs DSpace to register mp4 and mp3 files as bitstream formats
#If the format is not available one needs to manually add it after compiling DSpace
#TODO: install pdf.js
wget https://github.com/mozilla/pdf.js/archive/gh-pages.zip
unzip pdfjs-1.7.225-dist.zip -d /opt/tomcat/webapps/

#TODO install video.js 
wget https://github.com/videojs/video.js/releases/download/v6.2.1/video-js-6.2.1.zip
mkdir /opt/tomcat/webapps/ROOT/video.js
chown -R dspace /opt/tomcat/webapps/ROOT/video.js
unzip video-js-6.2.1.zip -d /opt/tomcat/webapps/ROOT/video.js/

#####################################
# Installing some postbuilds scripts
#######################################

popd
# run the compile.sh
bash ./compile.sh

# run postbuild.sh
bash ./postbuild.sh



