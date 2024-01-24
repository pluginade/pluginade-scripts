#!/bin/bash

while getopts 'p:c:n:w:s:' flag; do
	case "${flag}" in
		p) PLUGIN_PATH=${OPTARG} ;;
		c) COMMAND=${OPTARG} ;;
		n) INCLUDE_NODE_MODULES=${OPTARG} ;;
		w) WORKDIR=${OPTARG} ;;
		s) SHOWPLUGINADEDETAILS=${OPTARG} ;;
	esac
done

CWD=$(pwd)

WORKDIR='/usr/src/pluginade/pluginade-scripts/'

PLUGINBASENAME=$(basename "$PLUGIN_PATH")

#  Set up the downloads directory as a volume for the zip command, so we can put built zips there.
os_type="$(uname -s)"

if [ "$os_type" = "Linux" ]; then
	DOWNLOADSDIRECTORY="$HOME/Downloads"
elif [ "$os_type" = "Darwin" ]; then
	DOWNLOADSDIRECTORY="$HOME/Downloads"
elif [[ "$os_type" = MINGW* || "$os_type" = CYGWIN* ]]; then
	DOWNLOADSDIRECTORY="/c/Users/$(whoami)/Downloads"
else
	# Default to the plugin's zips directory.
	DOWNLOADSDIRECTORY=$PLUGIN_PATH/zips;
fi

# Build the string of volumes we want for this container.
EXTRAVOLUMES=""

if [ "$INCLUDE_NODE_MODULES" = "0" ]; then

	if [ -f "$PLUGIN_PATH/package.json" ];
	then
		EXTRAVOLUMES="$EXTRAVOLUMES -v /$PLUGINBASENAME/node_modules"
	fi

	# Loop through each wp-module in the plugin, and create a fake volume where the node_modules directory lives.
	# so that it doesn't get mounted (to speed up lint times dramatically).
	for DIR in "$PLUGIN_PATH"/wp-modules/*; do
		# If this module has a package.json file.
		if [ -f "$DIR/package.json" ];
		then
			MODULE_DIR_NAME="${DIR##*/}"
			EXTRAVOLUMES="$EXTRAVOLUMES -v /$PLUGINBASENAME/wp-modules/$MODULE_DIR_NAME/node_modules"
		fi
	
	done
fi

# Add a fake volume inside the plugin at .pluginade just in case pluginade has been cloned inside the plugin itself.
EXTRAVOLUMES="$EXTRAVOLUMES -v /$PLUGINBASENAME/.pluginade"

# Define the volumes to mount
PATH_TO_PLUGINADE_SCRIPTS="$(dirname "$CWD")"

# VOLUME_STRING="-v $PLUGINADE_SCRIPTS_VOLUME -v \"$PLUGIN_PATH\":/$PLUGINBASENAME -v $DOWNLOADSDIRECTORY_VOLUME $EXTRAVOLUMES"

# Build the docker image.
docker build -t pluginade .

# Run the docker container.
if [ "$SHOWPLUGINADEDETAILS" = "1" ]; then
	echo '-------'
	echo 'Starting the Pluginade docker container, built specifically for this job.'
	echo '-------'
	echo "docker run -v "$PATH_TO_PLUGINADE_SCRIPTS":/usr/src/pluginade/pluginade-scripts -v "$PLUGIN_PATH":/$PLUGINBASENAME -v "$DOWNLOADSDIRECTORY":/downloads -it -d pluginade"
	echo '-------'
	echo "Running Command inside Docker Container at location $WORKDIR:"
	echo $COMMAND
	echo '-------'
fi

CONTAINER_ID=$(docker run -v "$PATH_TO_PLUGINADE_SCRIPTS":/usr/src/pluginade/pluginade-scripts -v "$PLUGIN_PATH":/$PLUGINBASENAME -v "$DOWNLOADSDIRECTORY":/downloads -it -d pluginade)

if [ "$SHOWPLUGINADEDETAILS" = "1" ]; then
	echo '!!!theContainerId!!!'$CONTAINER_ID
fi

# Run the command passed-in.
docker exec -w $WORKDIR $CONTAINER_ID $COMMAND
THEEXITCODE=$?

if [ "$SHOWPLUGINADEDETAILS" = "1" ]; then
	echo '!!!theExitCode!!!'$THEEXITCODE
fi

# Stop and remove this container when finished.
RESULTOFDOCKERSTOP=$(docker stop $CONTAINER_ID)
RESULTOFDOCKERRM=$(docker rm $CONTAINER_ID)

# Remove any unused volumes.
RESULTOFDOCKERPRUNE=$(docker volume prune -f)

exit $THEEXITCODE