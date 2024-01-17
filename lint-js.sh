#!/bin/bash

# Run setup.
. ./setup.sh

# Check if there is an .eslintrc file in this project. If so, use it for standards. Otherwise,
if [ -f "$plugindir/.eslintrc" ];
then
	if [ "$fix" = "1" ]; then
		npm run lint:js "$plugindir" -- --config $plugindir/.eslintrc --fix;
	else
		npm run lint:js "$plugindir" -- --config $plugindir/.eslintrc;
	fi
else 
	if [ "$fix" = "1" ]; then
		npm run lint:js "$plugindir" -- --config .eslintrc --fix;
	else
		npm run lint:js "$plugindir" -- --config .eslintrc;
	fi
fi
