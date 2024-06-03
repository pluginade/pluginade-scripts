#!/bin/bash

# Run setup.
. ./setup.sh

# Delete the node_modules directory in the pluginade root.
echo 'Removing node_modules directory in the pluginade root.'
rm -rf node_modules

# Delete the vendor directory in the pluginade root.
echo 'Removing vendor directory in the pluginade root.'
rm -rf vendor

# Delete the playwright-browsers directory in the pluginade root.
echo 'Removing vendor directory in the pluginade root.'
rm -rf playwright-browsers

# Loop through each wp-module in the plugin.
for DIR in "$plugindir"/wp-modules/*; do
	# If this module has a package.json file.
	if [ -f "$DIR/package.json" ];
	then
		# Go to the directory of this wp-module.
		cd "$DIR";
		# Delete the node_modules directory in this wp-module.
		echo "Removing node_modules directory in $DIR"
		rm -rf node_modules
	fi
	# If this module has a composer.json file.
	if [ -f "$DIR/composer.json" ];
	then
		# Go to the directory of this wp-module.
		cd "$DIR";
		
		# Delete the vendor directory in this wp-module.
		echo "Removing vendor directory in $DIR"
		rm -rf vendor
	fi
	cd - > /dev/null
done

# Re-run install from scratch.
. ./install.sh

# Finish with a wait command, which lets a kill (cmd+c) kill all of the process created in this loop.
wait;