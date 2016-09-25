#!/bin/sh

# TODO: this does not work as env variables are not passed/accessible here.
if [[ $SUPERVISOR_DEBUG > 0 ]]; then
  echo "SUPERVISOR DEBUG"
  set -x
fi

DOCKER_BIN="/usr/local/bin/docker"
DC_BIN="/usr/local/bin/docker-compose"

DC_FILE="$1"
DC_PROJECT="$(dirname $DC_FILE)"
LOCK_FILE="$COMPOSE_PROJECT/.lock"

if [[ "$DC_FILE" != "" && -f $DC_FILE ]]; then
  # Switchig to the project directory - docker-compose will pick up settings from there.
  cd $DC_PROJECT

  # Using lockfile to avoid a race condition with multiple requests.
  if [[ ! -f $LOCK_FILE ]]; then
    touch $LOCK_FILE

    # Start containers.
    echo "Starting containers for $DC_PROJECT..."
    DC_OUTPUT=$($DC_BIN start 2>&1)
    echo $DC_OUTPUT

    # Figure out the default project network name from container names.
    # Unfortunatelly relying on DC_OUTPUT from above is not reliable, so we'll use ps here.
    #local network="$(echo $DC_OUTPUT | awk 'NR==3 {print $1}' | sed 's/\(.*\)_cli_1/\1/')_default"
    network="$($DC_BIN ps | awk 'NR==3 {print $1}' | sed 's/\(.*\)_cli_1/\1/')_default"
    # Connect proxy to the project network
    $DOCKER_BIN network connect "$network" vhost-proxy 2>&1 >/dev/null
    if [[ $? == 0 ]]; then
      echo "Connected proxy to network: ${network}."
    fi
    # Trigger docker-gen with a dummy container to refresh nginx configuration.
    echo "Trigerring docker-gen..."
    $DOCKER_BIN run --rm busybox

    rm -rf $LOCK_FILE
    exit 0
  else
    echo "Project is locked ($LOCK_FILE)."
    exit 1
  fi
fi
echo "ERROR: Invalid or empty DC_FILE."
exit 1
