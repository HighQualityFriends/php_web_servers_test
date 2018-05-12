#!/usr/bin/env bash

sysctl -w fs.file-max=2097152
sysctl -w vm.swappiness=20
sysctl -w vm.dirty_ratio=40
sysctl -w vm.dirty_background_ratio=10
echo never > /sys/kernel/mm/transparent_hugepage/enabled

sysctl -w net.ipv4.neigh.default.gc_thresh1=30000
sysctl -w net.ipv4.neigh.default.gc_thresh2=32000
sysctl -w net.ipv4.neigh.default.gc_thresh3=32768

sysctl -w net.core.somaxconn=100000
sysctl -w net.core.netdev_max_backlog=100000

sysctl -w net.ipv4.tcp_max_syn_backlog=8096
sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_rfc1337=1
sysctl -w net.ipv4.tcp_fin_timeout=15
sysctl -w net.ipv4.ip_local_port_range='1024 65535'

sysctl -w net.ipv4.tcp_keepalive_time=300
sysctl -w net.ipv4.tcp_keepalive_probes=5
sysctl -w net.ipv4.tcp_keepalive_intvl=15

sysctl -w net.ipv4.tcp_max_tw_buckets=1440000
sysctl -w net.ipv4.tcp_tw_recycle=1
ulimit -n 100000