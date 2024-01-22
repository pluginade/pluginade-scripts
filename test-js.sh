#!/bin/bash

# Run setup.
. ./setup.sh
. ./install-npm.sh

npm run test:js -- --roots "$plugindir"
