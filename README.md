docker rmi geofrizz/osmium_tool

docker build -t geofrizz/osmium_tool .


docker run -it --rm geofrizz/osmium_tool osmium --version
