#!/usr/bin/env bash
# Optional ad-blocking DNS: ./dns.sh on  (AdGuard Private DNS)  |  ./dns.sh off  (back to automatic)
# It blocks ad and tracker domains in most apps, but not YouTube ads.
set -euo pipefail
source "$(dirname "$0")/_common.sh"
case "${1:-}" in
  on)  TV "settings put global private_dns_specifier dns.adguard-dns.com"; TV "settings put global private_dns_mode hostname" ;;
  off) TV "settings put global private_dns_mode opportunistic" ;;
  *)   echo "usage: $0 on|off" >&2; exit 1 ;;
esac
TV "settings get global private_dns_mode"
