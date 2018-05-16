#!/usr/bin/env bash

echo "
fs.file-max=2000000

vm.swappiness=20
vm.dirty_ratio=40
vm.dirty_background_ratio=10

net.core.somaxconn=50000
net.core.netdev_max_backlog=40000

net.ipv4.neigh.default.gc_thresh1=30000
net.ipv4.neigh.default.gc_thresh2=32000
net.ipv4.neigh.default.gc_thresh3=32768

net.ipv4.ip_local_port_range = 1024 65000

net.ipv4.tcp_max_orphans = 60000
net.ipv4.tcp_fin_timeout=15

net.ipv4.tcp_keepalive_time=300
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=15

net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_max_tw_buckets=1440000

net.ipv4.tcp_max_syn_backlog=10000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies=1

net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_slow_start_after_idle=0

net.netfilter.nf_conntrack_tcp_timeout_established=86400

" >> /etc/sysctl.conf
sysctl -p

echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag

echo "
* soft     nproc          800000
* hard     nproc          800000
* soft     nofile         800000
* hard     nofile         800000
root soft     nproc          800000
root hard     nproc          800000
root soft     nofile         800000
root hard     nofile         800000
" >> /etc/security/limits.conf
echo  'session required pam_limits.so' >> /etc/pam.d/common-session
