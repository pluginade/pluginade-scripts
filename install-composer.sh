#!/bin/bash

# This file is designed to be included in other scripts, and assumes you are currently in the pluginade root directory.

# Install pluginade composer dependencies.
if [ ! -d vendor ] || [ -z "$(ls -A "vendor")" ]; then
	echo "Running composer install in pluginade root at $DIR..."
	composer install
fi

# Loop through each wp-module in the plugin, and install their dependencies.
for DIR in "$plugindir"/wp-modules/*; do
	# If this module has a composer.json file.
	if [ -f "$DIR/composer.json" ];then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		echo "Confirming composer dependencies for $DIR"

		if [ ! -d vendor ] || [ -z "$(ls -A "vendor")" ]; then
			echo "Running composer install..."
			composer install
		fi

		cd - > /dev/null
	fi

done