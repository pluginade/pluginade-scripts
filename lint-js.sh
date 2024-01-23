#!/bin/bash

# Run setup.
. ./setup.sh
. ./install-npm.sh

# Check if there is an .eslintrc file in this project. If so, use it for standards. Otherwise,
if [ -f "$plugindir/.eslintrc" ];
then
	# Copy the .eslintrc file from the plugin to pluginade.
	cp "$plugindir/.eslintrc" ".eslintrc";

	# Temporarily rename the .eslintrc file in the plugin to avoid conflicts.
	mv "$plugindir/.eslintrc" "$plugindir/.eslintrc-temp";
	eslintFileName=".eslintrc";
else 
	# Use the .eslintrc file from WP scripts in node_modules.
	eslintFileName="./node_modules/@wordpress/scripts/config/.eslintrc.js";
fi

if [ "$fix" = "1" ]; then
	npx wp-scripts lint-js "$plugindir" --config $eslintFileName --fix;
else
	npx wp-scripts lint-js "$plugindir" --config $eslintFileName;
fi

exit_code=$?

# Reset the .eslintrc file in the plugin.
if [ -f "$plugindir/.eslintrc-temp" ];
then
	mv "$plugindir/.eslintrc-temp" "$plugindir/.eslintrc";
fi

exit $exit_code;