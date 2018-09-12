#!/bin/sh

# Symlink certs for the default virtual host (if the default domain is set)
if [[ "$DEFAULT_CERT" != "" ]] && [[ "$DEFAULT_CERT" != "docksal" ]]; then
	if [[ -f /etc/certs/custom/${DEFAULT_CERT}.crt ]] && [[ -f /etc/certs/custom/${DEFAULT_CERT}.key ]]; then
		echo "Using a custom default certificate: '${DEFAULT_CERT}'"
		ln -sf /etc/certs/custom/${DEFAULT_CERT}.crt /etc/certs/server.crt
		ln -sf /etc/certs/custom/${DEFAULT_CERT}.key /etc/certs/server.key
	else
		echo "WARNING: Default certificate '${DEFAULT_CERT}' set, but no matching certificate files found in"
		echo -e "\t/etc/certs/custom/${DEFAULT_CERT}.crt"
		echo -e "\t/etc/certs/custom/${DEFAULT_CERT}.key"
	fi
fi

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
