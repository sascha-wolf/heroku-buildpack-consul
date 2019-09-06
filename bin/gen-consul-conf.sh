#!/usr/bin/env bash

: "${CONSUL_DATACENTER:?Need to set CONSUL_DATACENTER non-empty}"
: "${CONSUL_SERVER:?Need to set CONSUL_SERVER non-empty}"
# : "${HEROKU_PRIVATE_IP:?Need to set HEROKU_PRIVATE_IP non-empty}"
  # "bind_addr": "${HEROKU_PRIVATE_IP}",

CONSUL_CONFIG_DIR=/app/vendor/consul/

mkdir -p "$CONSUL_CONFIG_DIR"
cat >> ${CONSUL_CONFIG_DIR}/basic_config.json << EOFEOF
{
  "data_dir": "/tmp/consul/",
  "datacenter": "${CONSUL_DATACENTER//./_}",
  "leave_on_terminate": true,
  "log_level": "INFO",
  "node_name": "${DYNO}-$(cat /proc/sys/kernel/random/uuid | cut -d'-' -f1)",
  "performance": {
    "raft_multiplier": 1
  },
  "reconnect_timeout": "1m",
  "retry_join": "${CONSUL_SERVER}",
  "retry_interval": "1s",
  "skip_leave_on_interrupt": false
}
EOFEOF

# vim: syntax=json
