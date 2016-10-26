#!/usr/bin/env bash

: "${HEROKU_DNS_APP_NAME:?Need to set HEROKU_DNS_APP_NAME non-empty}"
: "${HEROKU_PRIVATE_IP:?Need to set HEROKU_PRIVATE_IP non-empty}"

CONSUL_CONFIG_DIR=/app/vendor/consul/

mkdir -p "$CONSUL_CONFIG_DIR"
cat >> ${CONSUL_CONFIG_DIR}/basic_config.json << EOFEOF
{
  "bind_addr": "${HEROKU_PRIVATE_IP}",
  "data_dir": "/tmp/consul/",
  "datacenter": "${HEROKU_DNS_APP_NAME//./_}",
  "leave_on_terminate": true,
  "log_level": "INFO",
  "node_name": "${DYNO}-$(cat /proc/sys/kernel/random/uuid | cut -d'-' -f1)",
  "performance": {
    "raft_multiplier": 1
  },
  "reconnect_timeout": "8h",
  "retry_join": $(jq '[.apps | .[] | .formation | .[] | .dynos | .[] | select(.hostname | contains("consul_server.${HEROKU_DNS_APP_NAME}")) | .hostname] | sort | reverse' /etc/heroku/space-topology.json)
  "retry_interval": "1s",
  "skip_leave_on_interrupt": false
}
EOFEOF

# vim: syntax=json
