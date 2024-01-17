#!/bin/bash

# Run setup.
. ./setup.sh

# Run the lint command from the wp-content directory.
if [ "$fix" = "1" ]; then
	npm run lint:css "$plugindir"/**/css/src/*.*css  -- --fix;
else
	npm run lint:css "$plugindir"/**/css/src/*.*css;
fi