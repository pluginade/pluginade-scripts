#!/bin/bash

# Run setup and build.
. ./build.sh

plugin_slug="$(basename "$plugindir")"

build_version=`grep 'Version:' "$plugindir"/$plugin_slug.php | cut -f4 -d' '`
zip_file_name="$plugin_slug.$build_version.zip"
cd "$(dirname "$plugindir")"

if [ -f "$plugindir/.zipignore" ]; then
	ignore_file="$plugindir/.zipignore"
elif [ -f "$plugindir/.distignore" ]; then
	ignore_file="$plugindir/.distignore"
else
	ignore_file="zipignore"
fi

echo "Using zipignore file: $ignore_file"

# Ensure every line in the ignore file begins and ends with *
sed "s/^[^*]/*&/g" "$ignore_file" | sed "s/[^*]$/&*/g" | xargs zip -r "$zip_file_name" "$plugin_slug" -x
mv "$zip_file_name" "/downloads"
echo "Created zip file: $zip_file_name"
