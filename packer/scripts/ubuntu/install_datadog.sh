#!/usr/bin/env bash
set -eux
set -o pipefail

sudo sh -c "echo 'deb http://apt.datadoghq.com/ stable main' > /etc/apt/sources.list.d/datadog.list"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52
sudo apt-get update -y
sudo apt-get install datadog-agent

sudo service datadog-agent stop
echo manual | sudo tee /etc/init/datadog-agent.override >/dev/null
