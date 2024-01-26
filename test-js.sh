#!/bin/bash

# Run setup.
. ./setup.sh
. ./install-npm.sh

# Check if there is an jest.config.js file in this project. If so, use it for standards. Otherwise,
if [ -f "$plugindir/jest.config.js" ];
then
	# Copy the jest.config.js file from the plugin to pluginade.
	cp "$plugindir/jest.config.js" "jest.config.js";

	# Temporarily rename the jest.config.js file in the plugin to avoid conflicts.
	mv "$plugindir/jest.config.js" "$plugindir/jest.config.js-temp";
	eslintFileName="jest.config.js";
else 
	# Use the jest.config.js file from pluginade.
	cp "$plugindir/jest.config.js.boiler" "jest.config.js";
fi

npx wp-scripts test-unit-js --passWithNoTests --config  --roots "$plugindir/wp-modules/app/"
