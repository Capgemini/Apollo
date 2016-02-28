#cloud-config

coreos:
  etcd2:
    # $public_ipv4 and v6 are populated by the cloud provider
    advertise-client-urls: "http://$public_ipv4:2379"
    initial-advertise-peer-urls: "http://$private_ipv4:2380"
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: "http://0.0.0.0:2379,http://0.0.0.0:4001"
    listen-peer-urls: "http://$private_ipv4:2380,http://$private_ipv4:7001"
    # Discovery is populated by Terraform
    discovery: ${etcd_discovery_url}
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
  update:
    reboot-strategy: best-effort
manage_etc_hosts: localhost