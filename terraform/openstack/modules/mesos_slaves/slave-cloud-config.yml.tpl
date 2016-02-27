#cloud-config

coreos:
  etcd2:
    # $public_ipv4 is populated by the cloud provider
    # Rackspace does not assign a private ip by default, unless we attach a compute resource to a private subnet (or ServiceNet).
    advertise-client-urls: http://$public_ipv4:2379,http://$public_ipv4:4001
    initial-advertise-peer-urls: http://$public_ipv4:2380
    # listen on both the official ports and the legacy ports
    # legacy ports can be omitted if your application doesn't depend on them
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$public_ipv4:2380
    # Discovery is populated by Terraform
    discovery: ${etcd_discovery_url}
  units:
    - name: format-ebs-volume.service
      command: start
      content: |
        [Unit]
        Description=Formats the ebs volume if needed
        Before=docker.service
        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=/bin/bash -c '(/usr/sbin/blkid -t TYPE=ext4 | grep /dev/xvdb) || (/usr/sbin/wipefs -fa /dev/xvdb && /usr/sbin/mkfs.ext4 /dev/xvdb)'
    - name: var-lib-docker.mount
      command: start
      content: |
        [Unit]
        Description=Mount ephemeral to /var/lib/docker
        Requires=format-ebs-volume.service
        After=format-ebs-volume.service
        [Mount]
        What=/dev/xvdb
        Where=/var/lib/docker
        Type=ext4
    - name: docker.service
      drop-ins:
        - name: 10-wait-docker.conf
          content: |
            [Unit]
            After=var-lib-docker.mount
            Requires=var-lib-docker.mount
  update:
    reboot-strategy: best-effort
manage_etc_hosts: localhost