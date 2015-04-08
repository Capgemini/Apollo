#!/bin/bash

set -eu
set -o pipefail

TERRAFORM=/usr/local/terraform/terraform
# @todo - prompt for $USER
# @todo - terraform apply here

/bin/sh -x ovpn-init
/bin/sh -x ovpn-start
/bin/sh -x ovpn-new-client $USER
/bin/sh -x ovpn-client-config $USER
# @todo Need to sed the .ovpn file to replace the correct IP address, because we are getting the
# instance IP address not the elastic IP address
/usr/bin/open $USER-capgemini-mesos.ovpn
# @todo Can we connect to the VPN here before opening the browser URLs

/usr/bin/open "http://$(terraform output master.0.ip):5050"
/usr/bin/open "http://$(terraform output master.0.ip):8080"
/usr/bin/open "http://$(terraform output master.0.ip):8500"

