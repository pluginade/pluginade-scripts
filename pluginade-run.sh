#!/bin/bash

# This file acts as a script runner for pluginade commands, simplifying the process of running commands for plugins.
while getopts 'p:c:t:n:' flag; do
	case "${flag}" in
		p) PLUGIN_PATH=${OPTARG} ;;
		c) COMMAND=${OPTARG} ;;
		t) TEXTDOMAIN=${OPTARG} ;;
		n) NAMESPACE=${OPTARG} ;;
	esac
done

PLUGINBASENAME=$(basename "$PLUGIN_PATH")

#  Start Dev Mode (npm run dev) for all wp-modules.
if [ $COMMAND == 'dev' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh dev.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 1 -s 1;
fi

#  Build Production (npm run build) for all wp-modules.
if [ $COMMAND == 'build' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh build.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 1 -s 1;
fi

#  PHP Linting. 
if [ $COMMAND == 'lint:php' ]; then
	# Run PHP Code Sniffer with WordPress Coding Standards.
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh phpcs.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 0 -s 1;
fi

# PHP Lint Fixing.
if [ $COMMAND == 'lint:php:fix' ]; then
	# Run PHP Code Sniffer with WordPress Coding Standards.
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh phpcs.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE} -f 1" -n 0 -s 1;
fi

# CSS Linting.
if [ $COMMAND == 'lint:css' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh lint-css.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE} -f 0" -n 0 -s 1;
fi

# CSS Lint Fixing.
if [ $COMMAND == 'lint:css:fix' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh lint-css.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE} -f 1" -n 0 -s 1;
fi

# JS Linting.
if [ $COMMAND == 'lint:js' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh lint-js.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE} -f 0" -n 1 -s 1;
fi

# JS Lint Fixing.
if [ $COMMAND == 'lint:js:fix' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh lint-js.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE} -f 1" -n 1 -s 1;
fi

# JS Jest Testing.
if [ $COMMAND == 'test:js' ]; then
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh test-js.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 1 -s 1;
fi

# PHP Unit Testing.
if [ $COMMAND == 'test:phpunit' ]; then
	# Run PHP Unit Tests.
	cd docker-phpunit;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh phpunit.sh -p -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 0 -s 1;
fi

# Create a WP installable zip of the plugin.
if [ $COMMAND == 'zip' ]; then
	# Run PHP Unit Tests.
	cd docker;
	sh run.sh -p "${PLUGIN_PATH}" -c "sh zip.sh -p /${PLUGINBASENAME} -t ${TEXTDOMAIN} -n ${NAMESPACE}" -n 0 -s 1;
fi
