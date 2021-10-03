#!/bin/sh

set -e

docker build -t ratings ../ratings/
docker build -t reviews ../reviews/
docker build -t details ../details/
docker build -t productpage ../productpage/
 
docker run --name ratings -p 8080:8080 -d ratings

docker run -d --name mongodb -p 27017:27017 \
  -v /home/natthasit_first/sitkmutt-devops-assignments/ratings/databases:/docker-entrypoint-initdb.d \
  bitnami/mongodb:5.0.2-debian-10-r2

docker run --name details -p 8081:8081 -d details

docker run --name reviews -e 'RATINGS_SERVICE=http://ratings:8080' -p 8082:9080 -d reviews

docker run --name productpage --link reviews:reviews --link ratings:ratings \
  --link reviews:reviews --link details:details \
  -e 'RATINGS_HOSTNAME=http://ratings:8080' -e 'DETAILS_HOSTNAME=http://details:8081' -e 'REVIEWS_HOSTNAME=http://reviews:9080' \
  -p 8083:8083 -d productpage