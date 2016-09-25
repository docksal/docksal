#!/bin/sh

set -x

DS_TIMEOUT="${INACTIVITY_TIMEOUT:-30m}"

# Get a list of runnig web containers (IDs)
running_webs=$(/usr/local/bin/docker ps -q --filter "label=com.docker.compose.service=web")

for container in $running_webs; do
  # Get project folder name
  project_folder=$(basename $(
    /usr/local/bin/docker inspect --format='{{range $val := .HostConfig.Binds}}{{$val}}{{end}}' $container | \
    grep /var/www:rw | \
    sed 's/:\/var\/www:rw//'
  ))
  # Get project name
  # Not necessary if using .env files for projects
  # See https://docs.docker.com/compose/env-file/
  project_name=$(
    /usr/local/bin/docker inspect --format='{{(index .Config.Labels "com.docker.compose.project")}}' $container
  )

  # See if there was any recent container activity (entries in container logs)
  if [ ! -z "$(/usr/local/bin/docker logs --tail 1 --since $DS_TIMEOUT $container)" ]; then
    # Active
    echo "Project: $project_name is active. Skipping."
  else
    # Not active
    echo "Project: $project_name is NOT active. Stopping..."
    # Stop
    cd /projects/$project_folder
    /usr/local/bin/docker-compose --project-name $project_name stop
  fi
done
