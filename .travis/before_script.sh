#!/usr/bin/env bash

# Regular project
git clone https://github.com/docksal/drupal7.git ../drupal7
cwd=$(pwd) && cd ../drupal7
fin start
cd $cwd

# Project with the "io.docksal.permanent" flag set to true
# This project will not be automatically cleaned even after DANGLING_TIMEOUT period.
git clone https://github.com/docksal/drupal8.git ../drupal8
cwd=$(pwd) && cd ../drupal8
local_yml="
version: '2.1'

services:
  web:
    labels:
      - io.docksal.permanent=true
"
echo "$local_yml" > .docksal/docksal-local.yml

fin start
cd $cwd
