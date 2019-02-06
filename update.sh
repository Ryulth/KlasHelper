#!/bin/sh

DIR=/home/uzussregi/project/KlasHelperRemaster
sudo git -C $DIR pull
docker-compose -f $DIR/docker-compose.yml down
docker-compose -f $DIR/docker-compose.yml up -d

