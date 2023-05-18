docker stop snort
docker rm snort
docker run -dit `
	-h snort `
	--name snort `
	--privileged=true `
	snort
docker exec -it snort bash