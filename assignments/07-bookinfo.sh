#!/bin/sh

set -e

docker build -t ratings ../ratings/
docker build -t reviews ../reviews/
docker build -t details ../details/
docker build -t productpage ../productpage/

docker run --name ratings -p 8080:8080 -d ratings
docker run --name details -p 8081:8081 -d details
docker run --name reviews -p 8082:9080 -d reviews
docker run --name productpage --link reviews:reviews --link ratings:ratings --link reviews:reviews --link details:details -e 'RATINGS_HOSTNAME=ratings_url' -e 'DETAILS_HOSTNAME=details_url' -e 'REVIEWS_HOSTNAME=reviews_url' -p 8083:8083 -d productpage