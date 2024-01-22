#!/bin/bash

while getopts 'p:n:t:f:' flag; do
	case "${flag}" in
		p) plugindir=${OPTARG} ;;
		n) namespace=${OPTARG} ;;
		t) textdomain=${OPTARG} ;;
		f) fix=${OPTARG} ;;
	esac
done

# If no plugin path is provided, then we assume that the plugin is mounted as a volume into the Docker container at /usr/src/pluginade/plugin
if [ ! -d "$plugindir" ]; then
	# The plugin is mounted as a volume into the Docker container at /usr/src/pluginade/plugin
	plugindir=/usr/src/pluginade/plugin
fi

plugindirname=$(basename "$plugindir")

# Make sure the node version matches.
nodeversion=$( node -v );
first3Chars=$(echo "$nodeversion" | cut -c1-3)

if [ "${first3Chars}" != 'v20' ]; then
	echo "Your version of node needs to be v14, but it is set to be "$nodeversion;
	exit 1;
fi
