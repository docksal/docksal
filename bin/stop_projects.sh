#!/bin/sh

DS_TIMEOUT="${INACTIVITY_TIMEOUT:-1h}"

# Get a list of runnig web containers (IDs)
running_webs=$(docker ps -q --filter "label=com.docker.compose.service=web")

for container in $running_webs; do
  # Get project path
  project_path=$(
    docker inspect --format='{{range $val := .HostConfig.Binds}}{{$val}}{{end}}' $container | \
    grep /var/www:rw | \
    sed 's/:\/var\/www:rw//'
  )
  # Get project name
  project_name=$(
    docker inspect --format='{{(index .Config.Labels "com.docker.compose.project")}}' $container
  )

  # See if there was any recent container activity (entries in container logs)
  if [[ $(docker logs --tail 1 --since $DS_TIMEOUT $container) != "" ]]; then
    # Active
    echo "Project: $project_name is active. Skipping."
  else
    # Not active
    echo "Project: $project_name is NOT active. Stopping..."
    # Stop
    docker-compose --file "$project_path/docker-compose.yml" --project-name $project_name stop
  fi
done
