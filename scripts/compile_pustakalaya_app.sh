# Compile and  Deploy custom pustakalaya-app
# Compile
cd ../pustakalaya-app
mvn install

# Deploy
rm -rf /dspace/webapps/pustakalaya-app
mkdir /dspace/webapps/pustakalaya-app
cp target/pustakalaya-app-1.5.6.RELEASE.war /dspace/webapps/pustakalaya-app

