#!/usr/bin/env bash

# Store build directory
cwd=$(pwd)

rm -rf ${cwd}/projects
mkdir -p ${cwd}/projects/project1
mkdir -p ${cwd}/projects/project2

# Regular project
cd ${cwd}/projects/project1
mkdir .docksal && mkdir docroot
echo "Hello world: Project 1" > docroot/index.html
fin reset -f

# Project with the "io.docksal.permanent" flag set to true
# This project will not be automatically cleaned even after DANGLING_TIMEOUT period.
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
