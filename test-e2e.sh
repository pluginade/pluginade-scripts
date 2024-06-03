#!/bin/bash

# Run setup.
. ./setup.sh
. ./install-npm.sh

echo $PWD;
ls;

# Check if there is an playwright.config.ts file in this project. If so, use it for standards. Otherwise,
if [ -f "$plugindir/playwright.config.ts" ];
then
	# Copy the playwright.config.ts file from the plugin to pluginade.
	cp "$plugindir/playwright.config.ts" "playwright.config.ts";

	# Temporarily rename the playwright.config.ts file in the plugin to avoid conflicts.
	mv "$plugindir/playwright.config.ts" "$plugindir/playwright.config.ts-temp";
	eslintFileName="playwright.config.ts";
else 
	# Use the playwright.config.ts file from pluginade.
	cp "playwright.config.ts.boiler" "playwright.config.ts";
fi

# Regardless of which file is used, we need to set the testDir to the plugin's path.
sed -i.bak "s/PluginadeWillReplaceThisWithThePluginPath/$plugindir/g" playwright.config.ts

# For Playwright, used the cached version of browsers to prevent downloading them every time the tests run.
playwrightBrowserDirectory="playwright-browsers/";

if [ ! -d "$playwrightBrowserDirectory" ]; then
	mkdir -p "$playwrightBrowserDirectory";
	PLAYWRIGHT_BROWSERS_PATH=$playwrightBrowserDirectory npx playwright install
fi

# npx wp-scripts test-unit-js --passWithNoTests --config  --roots "$plugindir/wp-modules/app/"
PLAYWRIGHT_BROWSERS_PATH=$playwrightBrowserDirectory npx wp-scripts test-playwright --config playwright.config.ts
