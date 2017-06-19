#!/usr/bin/env bash
# purpose: compile dspace and deploy to /dspace dir 

# Build the installation package
cd ../
# TODO: Install mirage2 without dependencies
mvn -U clean  package -Dmirage2.on=true
cd ./dspace/target/dspace-installer/
ant fresh_install 
systemctl restart tomcat
systemctl restart postgresql

# Run postbuild script
./postbuild.sh
