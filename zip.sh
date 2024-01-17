#!/bin/bash

# Run setup.
. ./setup.sh

plugin_slug="$(basename "$plugindir")"

build_version=`grep 'Version:' "$plugindir"/$plugin_slug.php | cut -f4 -d' '`
zip_file_name="$plugin_slug.$build_version.zip"
cd "$(dirname "$plugindir")"

if [ -f "$plugindir/.zipignore" ]; then
	ignore_file="$plugindir/.zipignore"
elif [ -f "$plugindir/.distignore" ]; then
	ignore_file="zipignore"
else
	echo "Error: please add a .zipignore to the root of the plugin"
	exit 1
fi

# Ensure every line in the ignore file begins and ends with *
sed "s/^[^*]/*&/g" "$ignore_file" | sed "s/[^*]$/&*/g" | xargs zip -r "$zip_file_name" "$plugin_slug" -x
mv "$zip_file_name" "/downloads"
