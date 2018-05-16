#!/usr/bin/env bash

echo "
fs.file-max=200000
vm.swappiness=20
vm.dirty_ratio=40
vm.dirty_background_ratio=10
net.ipv4.neigh.default.gc_thresh1=30000
net.ipv4.neigh.default.gc_thresh2=32000
net.ipv4.neigh.default.gc_thresh3=32768
net.core.somaxconn=100000
net.core.netdev_max_backlog=100000
net.ipv4.tcp_max_syn_backlog=10000
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_fin_timeout=15
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_keepalive_time=300
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=15
net.ipv4.tcp_max_tw_buckets=1440000
net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_syncookies=1
net.netfilter.nf_conntrack_generic_timeout = 300
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 120
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 60
net.netfilter.nf_conntrack_tcp_timeout_established = 86400
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 30
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close = 10
net.netfilter.nf_conntrack_tcp_timeout_max_retrans = 200
net.netfilter.nf_conntrack_tcp_timeout_unacknowledged = 200
net.netfilter.nf_conntrack_udp_timeout = 30
net.netfilter.nf_conntrack_udp_timeout_stream = 180
net.netfilter.nf_conntrack_icmp_timeout = 30
net.netfilter.nf_conntrack_events_retry_timeout = 15
" >> /etc/sysctl.conf
sysctl -p

echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "
* soft     nproc          100000
* hard     nproc          100000
* soft     nofile         100000
* hard     nofile         100000
root soft     nproc          100000
root hard     nproc          100000
root soft     nofile         100000
root hard     nofile         100000
" >> /etc/security/limits.conf
echo  'session required pam_limits.so' >> /etc/pam.d/common-session


echo "options nf_conntrack hashsize=50000" >> /etc/modprobe.d/nf_conntrack.conf
#systemctl stop ufw
#lsmod | grep nf_conntrack | xargs -I{} modprobe -rv
#systemctl start ufw