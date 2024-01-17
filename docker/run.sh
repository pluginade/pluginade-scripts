#!/bin/bash

while getopts 'p:c:n:w:s:' flag; do
	case "${flag}" in
		p) PLUGIN_PATH=${OPTARG} ;;
		c) COMMAND=${OPTARG} ;;
		n) INCLUDE_NODE_MODULES=${OPTARG} ;;
		w) WORKDIR=${OPTARG} ;;
		s) SHOWPLUGSIERDETAILS=${OPTARG} ;;
	esac
done

CWD=$(pwd)

WORKDIR='/usr/src/pluginade/pluginade-scripts/'

PLUGINBASENAME=$(basename "$PLUGIN_PATH")

#  Set up the downloads directory as a volume for the zip command, so we can put built zips there.
os_type="$(uname -s)"

if [ "$os_type" == "Linux" ]; then
	DOWNLOADSDIRECTORY="$HOME/Downloads"
elif [ "$os_type" == "Darwin" ]; then
	DOWNLOADSDIRECTORY="$HOME/Downloads"
elif [[ "$os_type" == MINGW* || "$os_type" == CYGWIN* ]]; then
	DOWNLOADSDIRECTORY="/c/Users/$(whoami)/Downloads"
else
	# Default to the plugin's zips directory.
	DOWNLOADSDIRECTORY=$PLUGIN_PATH/zips;
fi

# Define the volumes to mount
PLUGSIER_SCRIPTS_VOLUME="$(dirname "$CWD")"":/usr/src/pluginade/pluginade-scripts"
PLUGIN_VOLUME="$PLUGIN_PATH:/$PLUGINBASENAME"
DOWNLOADSDIRECTORY_VOLUME="$DOWNLOADSDIRECTORY"":/downloads"

# Build the string of volumes we want for this container.
VOLUME_STRING="-v $PLUGSIER_SCRIPTS_VOLUME -v $PLUGIN_VOLUME -v $DOWNLOADSDIRECTORY_VOLUME"

if [ "$INCLUDE_NODE_MODULES" = "0" ]; then

	if [ -f "$PLUGIN_PATH/package.json" ];
	then
		VOLUME_STRING="$VOLUME_STRING -v /$PLUGINBASENAME/node_modules"
	fi

	# Loop through each wp-module in the plugin, and create a fake volume where the node_modules directory lives.
	# so that it doesn't get mounted (to speed up lint times dramatically).
	for DIR in "$PLUGIN_PATH"/wp-modules/*; do
		# If this module has a package.json file.
		if [ -f "$DIR/package.json" ];
		then
			MODULE_DIR_NAME="${DIR##*/}"
			VOLUME_STRING="$VOLUME_STRING -v /$PLUGINBASENAME/wp-modules/$MODULE_DIR_NAME/node_modules"
		fi
	
	done
fi

# Add a fake volume inside the plugin at .pluginade just in case pluginade has been cloned inside the plugin itself.
VOLUME_STRING="$VOLUME_STRING -v /$PLUGINBASENAME/.pluginade"

# Build the docker container.
. ./build.sh

# Run the docker container.
if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
	echo '-------'
	echo 'Starting the Pluginade docker container, built specifically for this job.'
	echo '-------'
	echo "docker run $VOLUME_STRING -it -d pluginade"
	echo '-------'
	echo "Running Command inside Docker Container at location $WORKDIR:"
	echo $COMMAND
	echo '-------'
fi
CONTAINER_ID=$(docker run $VOLUME_STRING -it -d pluginade)

if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
	echo '!!!theContainerId!!!'$CONTAINER_ID
fi

# Run the command passed-in.
docker exec -w $WORKDIR $CONTAINER_ID $COMMAND
THEEXITCODE=$?

if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
	echo '!!!theExitCode!!!'$THEEXITCODE
fi

# Stop and remove this container when finished.
RESULTOFDOCKERSTOP=$(docker stop $CONTAINER_ID)
RESULTOFDOCKERRM=$(docker rm $CONTAINER_ID)

# Remove any unused volumes.
RESULTOFDOCKERPRUNE=$(docker volume prune -f)

exit $THEEXITCODE