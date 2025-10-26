#!/bin/bash
set -Eo pipefail

LOCAL_PORT="$API_PORT"
# shellcheck disable=SC2153
PUBLISHED_PORT="$SOCAT_PORT"
_RESTART="$SSH_RESTART"

while true; do
	printf "Forking :::%d onto 0.0.0.0:%d > trading mode %s (IPv6-aware)\n" \
		"${LOCAL_PORT}" "${PUBLISHED_PORT}" "${TRADING_MODE}"
	# IPv6-aware socat for Railway.com compatibility
	# TCP6-LISTEN accepts both IPv6 and IPv4 (via IPv4-mapped addresses)
	# ipv6only=0 allows the IPv6 socket to accept IPv4-mapped IPv6 connections
	# TCP4:127.0.0.1 forwards to IB Gateway as IPv4 localhost (bypasses TrustedIPs)
	socat TCP6-LISTEN:"${PUBLISHED_PORT}",ipv6only=0,reuseaddr,fork TCP4:127.0.0.1:"${LOCAL_PORT}"
	sleep "${_RESTART:-5}"
done
