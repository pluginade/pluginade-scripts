#!/bin/bash

# Run setup.
. ./setup.sh

npm run test:js -- --roots "$plugindir"
