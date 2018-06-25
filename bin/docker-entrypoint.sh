#!/bin/sh

# Connect networks
/usr/local/bin/proxyctl networks

# Service mode
if [[ "$1" == "supervisord" ]]; then
	# Generate config files from templates
	gomplate --file /etc/nginx/nginx.conf.tmpl --out /etc/nginx/nginx.conf

	exec supervisord -c /etc/supervisord.conf
# Command mode
else
	exec "$@"
fi
