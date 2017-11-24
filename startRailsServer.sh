#!/bin/bash
#
#
# IMPORTAN !!! NOT BEING USED BECAUSE IT'S ADDED TO DOCKERFILE ON VENTURE API 
/usr/bin/docker exec entoro-api  cp /myapp/config/database.yml.docker /myapp/config/database.yml
/usr/bin/docker exec entoro-api  rails s -b0