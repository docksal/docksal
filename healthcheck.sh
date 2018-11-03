#!/usr/bin/env bash

# supervisor services are running
if [[ -f /run/supervisord.pid ]]; then
	supervisorctl status docker-gen | grep RUNNING >/dev/null || exit 1
	supervisorctl status nginx | grep RUNNING >/dev/null || exit 1
	supervisorctl status crond | grep RUNNING >/dev/null || exit 1
fi

exit 1
