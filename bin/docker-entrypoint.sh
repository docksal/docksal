#!/bin/sh

# Connect networks.
/usr/local/bin/proxyctl networks

# Service mode (run as root)
if [[ "$1" == "supervisord" ]]; then
	exec supervisord -c /etc/supervisord.conf
# Command mode (run as docker user)
else
	exec "$@"
fi
