#!/usr/bin/env bats

load "helpers/bats-support/load"
load "helpers/bats-assert/load"
load "helpers/helper"

# 1.1
@test "1.1  - Keep Docker up to date" {
  docker_version=$(docker version | grep -i -A1 '^server' | grep -i 'version:' \
    | awk '{print $NF; exit}' | tr -d '[:alpha:]-,')
  docker_current_version="1.11.1"
  docker_current_date="2016-04-27"
  run do_version_check "$docker_current_version" "$docker_version"
  if [ $status -eq 11 ]; then
    fail "Using $docker_version, when $docker_current_version is current as of $docker_current_date. Your operating system vendor may provide support and security maintenance for docker."
  fi
  assert [ $status -eq 9 -o $status -eq 10 ]
}

# 1.2
@test "1.2  - Check for listening network services" {
  # Check for listening network services.
  listening_services=$(netstat -na | grep -v tcp6 | grep -v unix | grep -c LISTEN)
  if [ "$listening_services" -eq 0 ]; then
    fail "Failed to get listening services for check: $BATS_TEST_NAME"
  else
    if [ "$listening_services" -gt 5 ]; then
      fail "Host listening on: $listening_services ports"
    fi
  fi
}

# 1.3
@test "1.3  - Use an updated Linux Kernel" {
  kernel_version=$(uname -r | cut -d "-" -f 1)
  run do_version_check 3.10 "$kernel_version"
  assert [ $status -eq 9 -o $status -eq 10 ]
}

# 1.4
@test "1.4  - Only allow trusted users to control Docker daemon" {
  users_string=$(awk -F':' '/^docker/{print $4}' $(get_etc_path)/group)
  docker_users=(${users_string//,/ })
  for u in "${docker_users[@]}"; do
    found=1
    for tu in "${config_trusted_users[@]}"; do
      if [ "$u" = "$tu" ]; then
        found=0
      fi
    done
    if [ $found -eq 1 ]; then
      fail "User $u is not a trusted user!"
    fi
  done
}


# 2.1
@test "2.1  - Opened network traffic between containers" {
  result=$(get_docker_effective_command_line_args '--icc')
  [ "$output" = "" ]
}

# 2.2
@test "2.2  - Set the logging level" {
  result=$(get_docker_effective_command_line_args '-l')
  run grep 'debug' <<< "$result"
  assert_failure
}

# 2.3
@test "2.3  - Allow Docker to make changes to iptables" {
  result=$(get_docker_effective_command_line_args '--iptables')
  run grep "false" <<< "$result"
  assert_failure
}

# 3.1
@test "3.1  - Verify that docker.service file ownership is set to root:root" {
  file="$(get_systemd_service_file docker.service)"
  if [ -f "$file" ]; then
    if [ "$(stat -c %u%g "$file")" -ne 00 ]; then
      fail "Wrong ownership for $file"
    fi
  fi
}