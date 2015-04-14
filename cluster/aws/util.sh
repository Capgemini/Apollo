#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
APOLLO_ROOT=$(dirname "${BASH_SOURCE}")/../..
source "${APOLLO_ROOT}/cluster/aws/${APOLLO_CONFIG_FILE-"config-default.sh"}"
# This removes the final character in bash (somehow)
AWS_REGION=${ZONE%?}

verify_prereqs() {
  if [[ "$(which terraform)" == "" ]]; then
    echo -e "${color_red}Can't find terraform in PATH, please fix and retry.${color_norm}"
    exit 1
  fi
}

apollo_launch() {
  terraform_apply
  ovpn_start
  ovpn_client_config
}

apollo_down() {
  pushd $APOLLO_ROOT/terraform/aws
    terraform destroy
  popd
}

terraform_apply() {
  pushd $APOLLO_ROOT/terraform/aws
    terraform apply -var "access_key=${AWS_ACCESS_KEY_ID}" \
      -var "secret_key=${AWS_ACCESS_KEY}" \
      -var "key_file=${AWS_SSH_KEY}" \
      -var "key_name=${AWS_SSH_KEY_NAME}" \
      -var "atlas_token=${ATLAS_TOKEN}" \
      -var "instance_type.master=${MASTER_SIZE}" \
      -var "instance_type.slave=${SLAVE_SIZE}" \
      -var "slaves=${NUM_SLAVES}" \
      -var "subnet_availability_zone=${ZONE}" \
      -var "region=${AWS_REGION}"
  popd
}

ovpn_start() {
  pushd $APOLLO_ROOT/terraform/aws
    /bin/sh -x bin/ovpn-init
    /bin/sh -x bin/ovpn-start
  popd
}

ovpn_client_config() {
  pushd $APOLLO_ROOT/terraform/aws
    /bin/sh -x bin/ovpn-new-client $USER
    /bin/sh -x bin/ovpn-client-config $USER

    # We need to sed the .ovpn file to replace the correct IP address, because we are getting the
    # instance IP address not the elastic IP address in the downloaded file.
    nat_ip=$(terraform output nat.ip)
    /usr/bin/sed -i -e "s/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/${nat_ip}/g" $USER-capgemini-mesos.ovpn

    # Display a prompt to tell the user to open the $USER-capgemini-mesos.ovpn
    # in their VPN client and connect, and pause/wait for them to connect.
    while true; do
    read -p "Double click $USER-capgemini-mesos.ovpn to open the file and connect to the VPN.
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
    /usr/bin/open "http://$(terraform output master.0.ip):5050"
    /usr/bin/open "http://$(terraform output master.0.ip):8080"
    /usr/bin/open "http://$(terraform output master.0.ip):8500"
  popd
}
