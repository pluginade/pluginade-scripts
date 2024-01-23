#!/bin/bash

# Don't run setup. It's different for phpunit (no node needed, etc).
# . ./setup.sh

# Note that there are cases where you need node_modules to have been installed for phpunit to pass.
# For example, wp-scripts will sometimes generate PHP files from JS files, and can cause a run to fail. 
# For the cases, it is recommended to run install.sh before running phpunit.sh.
# The reason we don't run npm install here is because we don't mount the node_modules directory into the docker container.
# This speeds up phpunit tests by a lot, but it means that you need to run install.sh before running phpunit.sh if you need these generated php files.
while getopts 'p:n:t:f:' flag; do
	case "${flag}" in
		p) plugindir=${OPTARG} ;;
		n) namespace=${OPTARG} ;;
		t) textdomain=${OPTARG} ;;
		f) fix=${OPTARG} ;;
	esac
done

plugindirname=$(basename "$plugindir")

# Make sure the database docker container is ready.
echo 'Waiting for database to be ready...';
chmod +x ./wait-for-it.sh
./wait-for-it.sh db:3306 -t 60 -- echo "MySQL is ready!"

exitCode=$?

if [ $exitCode -ne 0 ]; then
	echo "Database is not ready. Exiting.";
	exit 1;
fi

# Go to the wordpress directory inside the Docker Container
cd /var/www/html;

# wp db create --allow-root;

echo 'Installing WordPress';
wp core install --url=localhost:8080 --title="Pluginade Test Site" --admin_user=admin --admin_password=password --admin_email=test@example.com --allow-root;

cd /usr/src/pluginade/pluginade-scripts;
composer install;

vendor/bin/phpunit --testdox -c ./phpunit.xml.dist /var/www/html/wp-content/plugins/$plugindirname