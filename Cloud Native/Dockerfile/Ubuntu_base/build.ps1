docker stop ubuntu_test
docker rm ubuntu_test
docker image rm ubuntu_test
docker build . -t ubuntu_test
docker exec -it ubuntu_test bash