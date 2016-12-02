#!/bin/sh

# Connect networks.
/usr/local/bin/proxyctl networks

# Start supervisor.
exec "$@"
