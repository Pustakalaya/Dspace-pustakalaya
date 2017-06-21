#!/usr/bin/env bash
# purpose: compile dspace and deploy to /dspace dir 

# Build the installation package
cd ../
# TODO: Install mirage2 without dependencies
mvn package -Dmirage2.on=true 
cd ./dspace/target/dspace-installer/
ant fresh_install 
systemctl restart tomcat
systemctl restart postgresql

cd -
# Run postbuild script
./postbuild.sh

# Run the filters media
/dspace/bin/dspace filter-media
