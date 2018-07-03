#!/usr/bin/env bash

# Store build directory
cwd=$(pwd)

rm -rf ${cwd}/projects
mkdir -p ${cwd}/projects/project1
mkdir -p ${cwd}/projects/project2
mkdir -p ${cwd}/projects/project3

# Regular project
cd ${cwd}/projects/project1
mkdir .docksal && mkdir docroot
echo "Hello world: Project 1" > docroot/index.html
fin reset -f

# Permanent project
# "io.docksal.permanent=true" (will not be automatically cleaned even after DANGLING_TIMEOUT period)
cd ${cwd}/projects/project2
mkdir .docksal && mkdir docroot
echo "Hello world: Project 2" > docroot/index.html
local_yml="
version: '2.1'

services:
  web:
    labels:
      - io.docksal.permanent=true
"
echo "$local_yml" > .docksal/docksal-local.yml
fin reset -f

# Nodejs app project
# "io.docksal.virtual-port=3000" (proxy forwards HTTP requests to a custom port 3000 instead of the default 80)
cd ${cwd}/projects/project3
git clone https://github.com/docksal/example-nodejs.git .
# Make this project permanent too, otherwise it will be killed before tests run
local_yml="
version: '2.1'

services:
  cli:
    labels:
      - io.docksal.permanent=true
"
echo "$local_yml" > .docksal/docksal-local.yml
fin reset -f

# Nodejs app (standalone container)
# Node need to make this one permanent ("io.docksal.permanent=true") since it is a standalone container and not a project
fin docker rm -vf nodejs || true
fin docker run -d --name=nodejs \
	-v $(pwd):/app \
	--label=io.docksal.virtual-host=nodejs.docksal \
	--label=io.docksal.virtual-port=3000 \
	--expose 3000 \
	node:alpine \
	node /app/index.js

# Custom certs
cd ${cwd}
cp -R tests/certs ~/.docksal
