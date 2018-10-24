#!/usr/bin/env bash

# supervisor services are running
if [[ -f /run/supervisord.pid ]]; then
	[[ ! -f /run/nginx.pid ]] && exit 1
	[[ ! -f /run/crond.pid ]] && exit 1
	supervisorctl status docker-gen | grep RUNNING >/dev/null || exit 1
fi

exit 0
