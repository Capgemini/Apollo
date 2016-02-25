#!/bin/bash

# Use the config file specified in $APOLLO_CONFIG_FILE, or default to
# config-default.sh.
function set_vpn() {
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
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    export APOLLO_bastion_ip=$( terraform output bastion.ip )

    # Virtual private cloud CIDR IP.
    ip=$( terraform output -module=vpc vpc_cidr_block )
    export APOLLO_network_identifier=$( get_network_identifier "${ip}" )

    cat <<EOF > ssh.config
  Host bastion $APOLLO_bastion_ip
    StrictHostKeyChecking  no
    User                   ubuntu
    HostName               $APOLLO_bastion_ip
    ProxyCommand           none
    IdentityFile           $TF_VAR_private_key_file
    BatchMode              yes
    PasswordAuthentication no
    UserKnownHostsFile     /dev/null

  Host $APOLLO_network_identifier.*
    StrictHostKeyChecking  no
    ServerAliveInterval    120
    TCPKeepAlive           yes
    ProxyCommand           ssh -q -A -F $(pwd)/ssh.config core@$APOLLO_bastion_ip nc %h %p
    ControlMaster          auto
    ControlPath            ~/.ssh/mux-%r@%h:%p
    ControlPersist         30m
    User                   core
    IdentityFile           $TF_VAR_private_key_file
    UserKnownHostsFile     /dev/null
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

ovpn_start() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    echo "... initialising VPN setup" >&2
    /bin/sh -x bin/ovpn-init
    /bin/sh -x bin/ovpn-start
  popd
}

ovpn_client_config() {
  pushd "${APOLLO_ROOT}/terraform/${APOLLO_PROVIDER}"
    echo "... creating VPN client configuration" >&2
    /bin/sh -x bin/ovpn-new-client "${TF_VAR_user}"
    /bin/sh -x bin/ovpn-client-config "${TF_VAR_user}"

    # We need to sed the .ovpn file to replace the correct IP address, because we are getting the
    # instance IP address not the elastic IP address in the downloaded file.
    bastion_ip=$(terraform output bastion.ip)
    /usr/bin/env sed -i -e "s/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/${bastion_ip}/g" "${TF_VAR_user-apollo.ovpn}"

    /usr/bin/open "${TF_VAR_user-apollo.ovpn}"
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
