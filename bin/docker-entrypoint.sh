#!/bin/sh

# Connect networks.
/usr/local/bin/proxyctl networks

# Service mode (run as root)
if [[ "$1" == "supervisord" ]]; then
	# Generate config files from templates
	gotpl /opt/conf/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf
	gotpl /opt/conf/nginx/proxyctl.conf.tmpl > /etc/nginx/proxyctl.conf

	exec supervisord -c /etc/supervisord.conf
# Command mode (run as docker user)
else
	exec "$@"
fi
