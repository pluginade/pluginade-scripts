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

PLUGIN_BASENAME=$(basename "$PLUGIN_PATH")

# Modify the docker-compose.yml file to include the volumes we want.
cp docker-compose-boiler.yml docker-compose.yml
sed -i.bak "s~LOCAL_PATH_TO_PLUGIN~$PLUGIN_PATH~g" docker-compose.yml
sed -i.bak "s~BASENAME_OF_PLUGIN~$PLUGIN_BASENAME~g" docker-compose.yml

		
# if [ "$INCLUDE_NODE_MODULES" = "0" ]; then

# 	if [ -f "$PLUGIN_PATH/package.json" ];
# 	then
# 		VOLUME_STRING="$VOLUME_STRING -v /usr/src/pluginade/plugin/node_modules"
# 	fi

# 	# Loop through each wp-module in the plugin, and create a fake volume where the node_modules directory lives.
# 	# so that it doesn't get mounted (to speed up lint times dramatically).
# 	for DIR in "$PLUGIN_PATH"/wp-modules/*; do
# 		# If this module has a package.json file.
# 		if [ -f "$DIR/package.json" ];
# 		then
# 			MODULE_DIR_NAME="${DIR##*/}"
# 			VOLUME_STRING="$VOLUME_STRING -v /usr/src/pluginade/plugin/wp-modules/$MODULE_DIR_NAME/node_modules"
# 		fi
	
# 	done
# fi

docker-compose build

# Run the docker container.
docker-compose up --build -d

if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
	echo '-------'
	echo 'Starting the Pluginade docker container, built specifically for this job.'
	echo '-------'
	echo "docker-compose up $VOLUME_STRING"
	echo '-------'
	echo "Running Command inside Docker Container at location $WORKDIR:"
	echo $COMMAND
	echo '-------'
fi
container_ids=$(docker-compose ps -q)

# Iterate over container IDs
for container_id in $container_ids; do
	echo "Processing container ID: $container_id"
	# Add your logic here

	containerName=$(docker ps --format '{{.Names}}' --filter id=$container_id)
	
	if [ "$containerName" = "pluginade-phpunit-wordpress" ]; then
		echo "Running phpunit"
		docker exec -w $WORKDIR $container_id $COMMAND
		THEEXITCODE=$?
	fi
done

# CONTAINER_ID=$(docker run $VOLUME_STRING -it -d pluginade-phpunit)

# if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
# 	echo '!!!theContainerId!!!'$CONTAINER_ID
# fi

# # Run the command passed-in.
# docker exec -w $WORKDIR $CONTAINER_ID $COMMAND
# THEEXITCODE=$?

# if [ "$SHOWPLUGSIERDETAILS" = "1" ]; then
# 	echo '!!!theExitCode!!!'$THEEXITCODE
# fi

for container_id in $container_ids; do
	# Stop and remove this container when finished.
	RESULTOFDOCKERSTOP=$(docker stop $container_id)
	# RESULTOFDOCKERRM=$(docker rm $CONTAINER_ID)
done

# Remove any unused volumes.
RESULTOFDOCKERPRUNE=$(docker volume prune -f)

exit $THEEXITCODE