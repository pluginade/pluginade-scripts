#!/bin/bash

# Don't run setup. It's different for phpunit (no node needed, etc).
# . ./setup.sh
while getopts 'p:n:t:f:' flag; do
	case "${flag}" in
		p) plugindir=${OPTARG} ;;
		n) namespace=${OPTARG} ;;
		t) textdomain=${OPTARG} ;;
		f) fix=${OPTARG} ;;
	esac
done

plugindirname=$(basename "$plugindir")

# There is still a race condition in circleCi here. The database is not ready yet.
# Temporary fix: sleep for 10 seconds.
echo 'Waiting for database to be ready...';

chmod +x ./wait-for-it.sh
./wait-for-it.sh db:3306 -t 60 -- echo "MySQL is ready!"

# Go to the wordpress directory inside the Docker Container
cd /var/www/html;

# wp db create --allow-root;

# sleep 10;

echo 'Installing WordPress';
wp core install --url=localhost:8080 --title="Pluginade Test Site" --admin_user=admin --admin_password=password --admin_email=test@example.com --allow-root;

cd /usr/src/pluginade/pluginade-scripts;
composer install;

vendor/bin/phpunit --testdox -c ./phpunit.xml.dist /var/www/html/wp-content/plugins/$plugindirname