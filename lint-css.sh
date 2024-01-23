#!/bin/bash

# Run setup.
. ./setup.sh

# Find CSS files and run stylelint if any are found
files=$(find "$plugindir" -type f -name "*.*css")

if [ -z "$files" ]; then
	echo "No CSS files found in $plugindir. Skipping stylelint."
	exit 0;
fi

# Install pluginade npm dependencies.
if [ ! -d node_modules ] || [ -z "$(ls -A "node_modules")" ]; then
	echo "Running npm install in pluginade root at $PWD..."
	npm install
fi

# Run the lint command from the wp-content directory.
if [ "$fix" = "1" ]; then
	npx wp-scripts lint-style "$plugindir"/**/*.*css --fix;
else
	npx wp-scripts lint-style "$plugindir"/**/*.*css;
fi