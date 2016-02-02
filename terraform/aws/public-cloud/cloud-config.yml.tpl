#cloud-config

write_files:
  - path: /etc/modules-load.d/nf.conf
    content: |
      nf_conntrack
  - path: /etc/sysctl.d/nf.conf
    content: |
      net.netfilter.nf_conntrack_max=131072
  - path: /etc/sysctl.d/99_swap.conf
    permissions: '0644'
    owner: root
    content: |
      vm.swappiness = 0
  - path: /etc/sysctl.d/99_filesystem.conf
    permissions: '0644'
    owner: root
    content: |
      vm.dirty_ratio = 80
      vm.dirty_background_ratio = 5
      vm.dirty_expire_centisecs = 12000
  - path: /etc/sysctl.d/99_networking.conf
    permissions: '0644'
    owner: root
    content: |
      net.core.somaxconn = 15000
      net.core.netdev_max_backlog = 25000
      net.core.rmem_max = 33554432
      net.core.wmem_max = 33554432
      net.ipv4.tcp_max_syn_backlog = 30000
      net.ipv4.tcp_slow_start_after_idle = 0
      net.ipv4.tcp_tw_reuse = 1
      net.ipv4.ip_local_port_range = 1024 65535
      net.ipv4.tcp_abort_on_overflow = 1

coreos:
  etcd2:
    # $public_ipv4 and $private_ipv4 are populated by the cloud provider
    advertise-client-urls: http://$public_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380,http://$private_ipv4:7001
    # Discovery is populated by Terraform
    discovery: ${etcd_discovery_url}
  fleet:
    public-ip: "$public_ipv4"
  units:
    - name: systemd-modules-load.service
      command: restart
    - name: systemd-sysctl.service
      command: restart
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
  update:
    reboot-strategy: "reboot"
manage_etc_hosts: localhost

