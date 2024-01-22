#!/bin/bash

# This file is designed to be included in other scripts, and assumes you are currently in the pluginade root directory.

# Install pluginade npm dependencies.
if [ ! -d node_modules ]; then
	npm install
else
	# Run npm outdated and capture the output
	outdated_info=$(npm outdated --json)
	
	# Check if there are outdated packages
	if [ "$outdated_info" != "{}" ]; then
		echo "Outdated npm packages found. Running npm install..."
		echo $outdated_info;
		# Acceptable to use force here because these are dependencies managed by pluginade, not the plugin itself.
		npm install --force
	fi
fi

# Loop through each wp-module in the plugin, and install their dependencies.
for DIR in "$plugindir"/wp-modules/*; do
	# If this module has a package.json file.
	if [ -f "$DIR"/package.json ]; then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		echo "Confirming npm dependencies for $DIR"

		# Run npm install for this module.
		if [ ! -d node_modules ] || [ -z "$(ls -A "$DIR/node_modules")" ]; then
			echo "Running npm install..."
			npm install
		else
			# Run npm outdated and capture the output
			outdated_info=$(npm outdated --json)
			
			# Check if there are outdated packages
			if [ "$outdated_info" != "{}" ]; then
				echo "Outdated npm packages found. Running npm install..."
				echo $outdated_info;
				npm install
			fi
		fi
		
		cd - > /dev/null
	fi

done