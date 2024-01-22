#!/bin/bash

# Run setup.
. ./setup.sh

# Loop through each wp-module in the plugin.
for DIR in "$plugindir"/wp-modules/*; do
	# If this module has a package.json file.
	if [ -f "$DIR/package.json" ];
	then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		# If this module does not have a node_modules directory, or if it is empty.
		if [ ! -d node_modules ] || [ -z "$(ls -A "node_modules")" ]; then
			npm install &
		fi

		# Run the build script for this module.
		npm run dev &
	fi

	# If this module has a composer.json file.
	if [ -f "$DIR/composer.json" ];
	then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		# If this module does not have a vendor directory, or if it is empty.
		if [ ! -d vendor ] || [ -z "$(ls -A "vendor")" ]; then
			composer install &
		fi
	fi

done

# Finish with a wait command, which lets a kill (cmd+c) kill all of the process created in this loop.
wait;