#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.

ansible_ssh_config() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    cat <<EOF > ssh.config
  Host *
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   ubuntu
    UserKnownHostsFile     /dev/null
EOF
  popd
}

mount_docker_volume_script() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"

    cat <<EOF > mount.ssh
  #!/usr/bin/env bash
  set -eux
  set -o pipefail

  while [ ! -e /dev/xvdb ]; do sleep 1; done

  fstab_string='/dev/xvdb /var/lib/docker ext4 defaults,nofail,nobootwait 0 2'
  if grep -q -F -v "$fstab_string" /etc/fstab; then
    echo "$fstab_string" | sudo tee -a /etc/fstab
  fi

  sudo rm -rf /var/lib/docker && sudo mkdir -p /var/lib/docker && \
    sudo mkfs -t ext4 /dev/xvdb && sudo mount -t ext4 /dev/xvdb /var/lib/docker
EOF
  popd
}

apollo_down() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    terraform destroy -var "access_key=${TF_VAR_access_key}" \
      -var "key_file=${TF_VAR_key_file}" \
      -var "region=${TF_VAR_region}"
  popd
}

