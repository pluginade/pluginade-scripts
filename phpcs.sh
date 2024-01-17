#!/bin/bash

# Run setup.
. ./setup.sh

# Duplicate the phpcs.xml boiler, and call it phpcs.xml.
cp phpcs-boiler.xml phpcs.xml

# Modify the phpcs.xml file in the pluginade module to contain the namespace and text domain of the plugin in question.
sed -i.bak "s/MadeWithPLUGINADE/$namespace/g" phpcs.xml
sed -i.bak "s/madewithpluginade/$textdomain/g" phpcs.xml

if [ -f "$plugindir/.phpcs.xml" ]; then
	# Use the phpcs.xml file located in the plugin itself, allowing it to set its own standards.
	pathToPhpcsXmlFile="$plugindir/.phpcs.xml"
else
	pathToPhpcsXmlFile="phpcs.xml"
fi

# Run the phpcs command from the wp-content directory.
if [ "$fix" = "1" ]; then
	./vendor/bin/phpcbf -q -p "$pathToPhpcsXmlFile" "$plugindir" --basepath=""
	./vendor/bin/phpcs -q -p "$pathToPhpcsXmlFile" "$plugindir";
else
	./vendor/bin/phpcs -q -p "$pathToPhpcsXmlFile" "$plugindir";
fi