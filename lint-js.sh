#!/bin/bash

# Run setup.
. ./setup.sh

# Check if there is an .eslintrc file in this project. If so, use it for standards. Otherwise,
if [ -f "$plugindir/.eslintrc" ];
then
	# Copy the .eslintrc file from the plugin to pluginade.
	cp "$plugindir/.eslintrc" ".eslintrc";

	# Temporarily rename the .eslintrc file in the plugin to avoid conflicts.
	mv "$plugindir/.eslintrc" "$plugindir/.eslintrc-temp";
	eslintFileName=".eslintrc";
else 
	# Copy the .eslintrc file WP scripts in node_modules to pluginade.
	cp ./node_modules/@wordpress/scripts/config/.eslintrc.js ".eslintrc.js";
	eslintFileName=".eslintrc.js";
fi

if [ "$fix" = "1" ]; then
	npm run lint:js "$plugindir" -- --config $eslintFileName --fix;
else
	npm run lint:js "$plugindir" -- --config $eslintFileName;
fi

# Reset the .eslintrc file in the plugin.
if [ -f "$plugindir/.eslintrc-temp" ];
then
	mv "$plugindir/.eslintrc-temp" "$plugindir/.eslintrc";
fi