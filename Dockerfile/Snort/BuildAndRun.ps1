docker stop snort
docker rm snort
docker image rm snort
docker build . -t snort
docker run -dit `
	-h snort `
	--name snort `
	--privileged=true `
	snort
docker exec -it snort bash