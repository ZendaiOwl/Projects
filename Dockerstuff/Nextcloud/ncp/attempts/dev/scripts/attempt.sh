#!/usr/bin/env bash

docker run --rm -it --privileged \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(pwd)/docker-compose.yml:/docker-compose.yml \
           -v ./.env:/.env docker/compose docker-compose up


