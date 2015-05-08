#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..
source "${APOLLO_ROOT}/bootstrap/aws/${APOLLO_CONFIG_FILE-"config-default.sh"}"

verify_prereqs() {
  if [[ "$(which terraform)" == "" ]]; then
    echo -e "${color_red}Can't find terraform in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
  if [[ "$(which ansible-playbook)" == "" ]]; then
    echo -e "${color_red}Can't find ansible-playbook in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
  if [[ "$(which python)" == "" ]]; then
    echo -e "${color_red}Can't find python in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
  if [[ "$(pip list | grep boto)" == "" ]]; then
    echo -e "${color_red}Can't find Boto. Please install it via pip install boto.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  terraform_apply
  ansible_ssh_config
  ansible_playbook_run

  while true; do
  read -p "Do you want to start the VPN and setup a connection now (y/n)?" yn
    case $yn in
        [Yy]* ) ovpn_start;ovpn_client_config; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
  done
}

ansible_ssh_config() {
  pushd $APOLLO_ROOT/terraform/aws
    NAT_IP=$(terraform output nat.ip)
    cat <<EOF > ssh.config
  Host nat
    StrictHostKeyChecking  no
    User                   ubuntu
    HostName               $NAT_IP
    ProxyCommand           none
    IdentityFile           $AWS_SSH_KEY
    BatchMode              yes
    PasswordAuthentication no

  Host *
    StrictHostKeyChecking  no
    ServerAliveInterval    60
    TCPKeepAlive           yes
    ProxyCommand           ssh -q -A ubuntu@$NAT_IP nc %h %p
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         8h
    User                   ubuntu
    IdentityFile           $AWS_SSH_KEY
EOF
  popd
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    ANSIBLE_SSH_ARGS="-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o \
    ControlPersist=60s -F $APOLLO_ROOT/terraform/aws/ssh.config -q" \
    ansible-playbook --user=ubuntu --inventory-file=$APOLLO_ROOT/inventory/aws \
    --extra-vars "mesos_cluster_name=${MESOS_CLUSTER_NAME} \
      mesos_slave_work_dir=${SLAVE_WORK_DIR} \
      consul_dc=${CONSUL_DC} \
      consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN}" \
      --sudo site.yml
  popd
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/aws
    terraform destroy
  popd
}

terraform_apply() {
  pushd $APOLLO_ROOT/terraform/aws
    terraform apply -var "access_key=${AWS_ACCESS_KEY_ID}" \
      -var "secret_key=${AWS_SECRET_ACCESS_KEY}" \
      -var "key_file=${AWS_SSH_KEY}" \
      -var "key_name=${AWS_SSH_KEY_NAME}" \
      -var "atlas_token=${ATLAS_TOKEN}" \
      -var "atlas_infrastructure=${ATLAS_INFRASTRUCTURE}" \
      -var "instance_type.master=${MASTER_SIZE}" \
      -var "instance_type.slave=${SLAVE_SIZE}" \
      -var "atlas_artifact.master=${ATLAS_ARTIFACT_MASTER}" \
      -var "atlas_artifact.slave=${ATLAS_ARTIFACT_SLAVE}" \
      -var "slaves=${NUM_SLAVES}" \
      -var "subnet_availability_zone=${ZONE}" \
      -var "region=${AWS_REGION}"
  popd
}

ovpn_start() {
  pushd $APOLLO_ROOT/terraform/aws
    echo "... initialising VPN setup" >&2
    /bin/sh -x bin/ovpn-init
    /bin/sh -x bin/ovpn-start
  popd
}

ovpn_client_config() {
  pushd $APOLLO_ROOT/terraform/aws
    echo "... creating VPN client configuration" >&2
    /bin/sh -x bin/ovpn-new-client $USER
    /bin/sh -x bin/ovpn-client-config $USER

    # We need to sed the .ovpn file to replace the correct IP address, because we are getting the
    # instance IP address not the elastic IP address in the downloaded file.
    nat_ip=$(terraform output nat.ip)
    /usr/bin/sed -i -e "s/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/${nat_ip}/g" $USER-apollo-mesos.ovpn

    /usr/bin/open $USER-apollo-mesos.ovpn
    # Display a prompt to tell the user to connect in their VPN client,
    # and pause/wait for them to connect.
    while true; do
    read -p "Your VPN client should be open. Please now connect to the VPN using your VPN client.
      Once connected hit y to open the web interface or n to exit (y/n)?" yn
      case $yn in
          [Yy]* ) popd;open_urls; break;;
          [Nn]* ) popd;exit;;
          * ) echo "Please answer y or n.";;
      esac
    done
}

open_urls() {
  pushd $APOLLO_ROOT/terraform/aws
    /usr/bin/open "http://$(terraform output master.1.ip):5050"
    /usr/bin/open "http://$(terraform output master.1.ip):8080"
    /usr/bin/open "http://$(terraform output master.1.ip):8500"
  popd
}
