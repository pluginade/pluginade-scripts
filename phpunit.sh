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

# Go to the wordpress directory inside the Docker Container
cd /var/www/html;

wp db create --allow-root;

wp core install --url=localhost:8080 --title="Pluginade Test Site" --admin_user=admin --admin_password=password --admin_email=test@example.com --allow-root;

cd /usr/src/pluginade/pluginade-scripts;
composer install;

vendor/bin/phpunit -c ./phpunit.xml.dist /var/www/html/wp-content/plugins/$plugindirname
