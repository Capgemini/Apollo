#cloud-config

coreos:
  etcd2:
    discovery: ${etcd_discovery_url}
    advertise-client-urls: http://$public_ipv4:2379
    initial-advertise-peer-urls: http://$public_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379
    listen-peer-urls: http://$public_ipv4:2380
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
