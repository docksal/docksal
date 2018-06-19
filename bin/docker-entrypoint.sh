#!/bin/sh

# Connect networks.
/usr/local/bin/proxyctl networks

# Service mode (run as root)
if [[ "$1" == "supervisord" ]]; then
	# Generate config files from templates
	gomplate --file /opt/conf/nginx/nginx.conf.tmpl --out /etc/nginx/nginx.conf
	gomplate --file /opt/conf/nginx/proxyctl.conf.tmpl --out /etc/nginx/proxyctl.conf

	exec supervisord -c /etc/supervisord.conf
# Command mode (run as docker user)
else
	exec "$@"
fi
