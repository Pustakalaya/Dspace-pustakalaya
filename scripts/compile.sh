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
cd scripts
# Run postbuild script
./postbuild.sh

# Compile and  Deploy custom pustakalaya-app
# bash ./compile_pustakalaya_app.sh
