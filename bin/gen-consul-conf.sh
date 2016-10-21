#!/usr/bin/env bash

: "${HEROKU_DNS_APP_NAME:?Need to set HEROKU_DNS_APP_NAME non-empty}"
: "${HEROKU_PRIVATE_IP:?Need to set HEROKU_PRIVATE_IP non-empty}"

CONSUL_CONFIG_DIR=/app/vendor/consul/

mkdir -p "$CONSUL_CONFIG_DIR"
cat >> ${CONSUL_CONFIG_DIR}/basic_config.json << EOFEOF
{
  "bind_addr": "${HEROKU_PRIVATE_IP}",
  "bootstrap_expect": 3,
  "data_dir": "/tmp/consul/",
  "datacenter": "${HEROKU_DNS_APP_NAME}",
  "leave_on_terminate": true,
  "log_level": "INFO",
  "node_name": "$(cat /proc/sys/kernel/random/uuid)",
  "raft_multiplier": 1,
  "reconnect_timeout": "8h",
  "retry_join": [
    "1.consul_server.${HEROKU_DNS_APP_NAME}",
    "2.consul_server.${HEROKU_DNS_APP_NAME}",
    "3.consul_server.${HEROKU_DNS_APP_NAME}",
    "4.consul_server.${HEROKU_DNS_APP_NAME}",
    "5.consul_server.${HEROKU_DNS_APP_NAME}"
  ],
  "skip_leave_on_interrupt": false
}
EOFEOF

# vim: syntax=json ts=4 sw=4 sts=4 sr noet
