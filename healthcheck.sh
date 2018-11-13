#!/usr/bin/env bash

# nginx config is valid
nginx -t || exit 1

# supervisor services are running
if [[ -f /run/supervisord.pid ]]; then
	supervisorctl status docker-gen | grep RUNNING >/dev/null || exit 1
	supervisorctl status nginx | grep RUNNING >/dev/null || exit 1
	supervisorctl status crond | grep RUNNING >/dev/null || exit 1

	exit 0
fi

exit 1
