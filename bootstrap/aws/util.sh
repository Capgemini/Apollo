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

  check_terraform_version

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
    UserKnownHostsFile     /dev/null

  Host *
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    TCPKeepAlive           yes
    ProxyCommand           ssh -q -A ubuntu@$NAT_IP nc %h %p
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   ubuntu
    IdentityFile           $AWS_SSH_KEY
    UserKnownHostsFile     /dev/null
EOF
  popd
}

ansible_playbook_run() {
  pushd $APOLLO_ROOT
    ANSIBLE_SSH_ARGS="-F $APOLLO_ROOT/terraform/aws/ssh.config -q" \
    ansible-playbook --user=ubuntu --inventory-file=$APOLLO_ROOT/inventory/aws \
    --extra-vars "consul_atlas_infrastructure=${ATLAS_INFRASTRUCTURE} \
      consul_atlas_join=true \
      consul_atlas_token=${ATLAS_TOKEN} \
      $(get_apollo_variables)" \
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
    terraform apply -var "instance_type.master=${TF_VAR_master_size}" \
      -var "instance_type.slave=${TF_VAR_slave_size}" \
      -var "atlas_artifact.master=${TF_VAR_atlas_artifact_master}" \
      -var "atlas_artifact.slave=${TF_VAR_atlas_artifact_slave}"
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
    /bin/sh -x bin/ovpn-new-client $TF_VAR_user
    /bin/sh -x bin/ovpn-client-config $TF_VAR_user

    # We need to sed the .ovpn file to replace the correct IP address, because we are getting the
    # instance IP address not the elastic IP address in the downloaded file.
    nat_ip=$(terraform output nat.ip)
    /usr/bin/sed -i -e "s/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/${nat_ip}/g" $TF_VAR_user-apollo.ovpn

    /usr/bin/open $TF_VAR_user-apollo.ovpn
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
