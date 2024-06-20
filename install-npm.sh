#!/bin/bash

# This file is designed to be included in other scripts, and assumes you are currently in the pluginade root directory.

# Install pluginade npm dependencies.
if [ ! -d node_modules ] || [ -z "$(ls -A "node_modules")" ]; then
	echo "Running npm install in pluginade root at $PWD..."
	# Sync the WP external global packages (like react, etc) in package.json with the WordPress version defined in the plugin's readme.txt file.
	# See external packages https://github.com/WordPress/gutenberg/tree/trunk/packages/dependency-extraction-webpack-plugin
	. /usr/src/pluginade/pluginade-scripts/sync-wp-global-packages.sh

	npm install
fi

# Loop through each wp-module in the plugin, and install their dependencies.
for DIR in "$plugindir"/wp-modules/*; do
	# If this module has a package.json file.
	if [ -f "$DIR"/package.json ]; then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		echo "Confirming npm dependencies for $DIR"

		# Sync the WP external global packages (like react, etc) in package.json with the WordPress version defined in the plugin's readme.txt file.
		# See external packages https://github.com/WordPress/gutenberg/tree/trunk/packages/dependency-extraction-webpack-plugin
		. /usr/src/pluginade/pluginade-scripts/sync-wp-global-packages.sh

		# Run npm install for this module.
		if [ ! -d node_modules ] || [ -z "$(ls -A "$DIR/node_modules")" ]; then
			echo "Running npm install..."
			npm install
		fi
		
		cd - > /dev/null
	fi

done