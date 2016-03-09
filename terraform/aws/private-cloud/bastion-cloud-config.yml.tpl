#cloud-config

coreos:
  etcd2:
    proxy: on
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    discovery: ${etcd_discovery_url}
  fleet:
    metadata: "role=bastion,region=${region}"
    etcd_servers: "http://localhost:2379"
  locksmith:
    endpoint: "http://localhost:2379"
  units:
    - name: docker.service
      command: start
    - name: etcd2.service
      command: start
  update:
    reboot-strategy: best-effort
manage_etc_hosts: localhost
