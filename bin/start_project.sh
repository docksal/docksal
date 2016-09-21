#!/bin/sh

set -x

if [[ "$1" != "" && -f "$1" ]]; then
  export COMPOSE_FILE="$1"

  # Figure out the default project network name
  # TODO: refactor into something less hacky
  local network="$(/usr/bin/docker-compose ps cli | awk 'NR==3 {print $1}' | sed 's/_cli_1//')_default"
  #docker network connect "$network" vhost-proxy >/dev/null 2>&1
  /usr/local/bin/docker network connect "$network" vhost-proxy
  # Restart services if vhost-proxy was connected (first time) to the project network
  # TODO: figure out how to avoid doing a restart
  if [[ $? == 0 ]]; then
    echo "Connected vhost-proxy to \"${network}\" network."
  fi

  # Start containers.
  /usr/bin/docker-compose start
  #/usr/bin/docker-compose up -d

  exit 0
fi
exit 1
