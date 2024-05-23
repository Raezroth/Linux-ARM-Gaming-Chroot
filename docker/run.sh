docker container create --privileged --network host --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=$DISPLAY --name gaming arm-gaming-64
docker start gaming
