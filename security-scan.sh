#!/bin/bash

# Run setup.
. ./setup.sh

# Duplicate the phpcs-security-only.xml boiler, and call it phpcs.xml.
cp phpcs-security-only.xml phpcs.xml

if [ -f "$plugindir/phpcs.xml" ]; then
	# Copy the phpcs.xml file located in the plugin itself, into pluginade so it gets used.
	cp "$plugindir/phpcs.xml" phpcs.xml
fi

./vendor/bin/phpcs --report=json -s -p "$plugindir";