#!/bin/bash

# Run setup.
. ./setup.sh
. ./install-npm.sh

npx wp-scripts test-unit-js --passWithNoTests --roots "$plugindir"
