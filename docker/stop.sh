# Stop the docker container.
docker stop $(docker ps -a -q --filter ancestor=pluginade) 