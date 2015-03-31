cat >> /etc/sysctl.conf << EOM

# https://ckon.wordpress.com/2013/03/11/centos-6-4-supports-iw10-tcpip-tuning/
net.ipv4.tcp_slow_start_after_idle=0

# https://tools.ietf.org/html/draft-ietf-tcpm-fastopen-10
net.ipv4.tcp_fastopen = 1
EOM

sudo sysctl -p

cat >> /etc/rc.local << EOM

# https://ckon.wordpress.com/2013/03/11/centos-6-4-supports-iw10-tcpip-tuning/
DEF=\`ip route show | grep ^default\`
ip route change \$DEF initcwnd 10 initrwnd 10
EOM