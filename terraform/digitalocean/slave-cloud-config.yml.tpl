#cloud-config

coreos:
  etcd2:
    proxy: on
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    discovery: ${etcd_discovery_url}
  fleet:
    metadata: "role=slave,region=${region}"
    etcd_servers: "http://localhost:2379"
  locksmith:
    endpoint: "http://localhost:2379"
  units:
    - name: etcd2.service
      command: start
  update:
    reboot-strategy: best-effort
write_files:
  - path: /run/systemd/system/etcd.service.d/30-certificates.conf
    permissions: 0644
    content: |
      [Service]
      Environment=ETCD_CA_FILE=/etc/ssl/etcd/certs/ca.pem
      Environment=ETCD_CERT_FILE=/etc/ssl/etcd/certs/etcd.pem
      Environment=ETCD_KEY_FILE=/etc/ssl/etcd/private/etcd.pem
      Environment=ETCD_PEER_CA_FILE=/etc/ssl/etcd/certs/ca.pem
      Environment=ETCD_PEER_CERT_FILE=/etc/ssl/etcd/certs/etcd.pem
      Environment=ETCD_PEER_KEY_FILE=/etc/ssl/etcd/private/etcd.pem
  - path: /etc/ssl/etcd/certs/ca.pem
    permissions: 0644
    content: "${etcd_ca}"
  - path: /etc/ssl/etcd/certs/etcd.pem
    permissions: 0644
    content: "${etcd_cert}"
  - path: /etc/ssl/etcd/private/etcd.pem
    permissions: 0644
    content: "${etcd_key}"
manage_etc_hosts: localhost
role: mesos_slaves
