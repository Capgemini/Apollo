#!/bin/bash

set -e

ec2_hostname() {
  declare ip="$1"
  echo ip-$(echo "$ip" | sed -e 's/\./-/g')
}

wait_ssh_ready() {
  declare node="$1"
  while ! ssh -o ConnectTimeout=3 "$node" true >/dev/null 2>&1; do
    sleep 1
  done
}

zk_id() {
  declare node="$1"
  local id=1
  for ip in $(cat /home/ubuntu/masters); do
    master=$(ec2_hostname "$ip")
    if [ "$node" == "$master" ]; then
      echo "$id"
      return
    else
      id=$(expr $id + 1)
    fi
  done
}

set_zookeeper_myid() {
  declare node="$1"
  local id=$(zk_id "$node")
  ssh "$node" "echo $id | sudo tee /etc/zookeeper/conf/myid"
}

set_zookeeper_cfg() {
  declare node="$1"
  local id=1
  for ip in $(cat /home/ubuntu/masters); do
    ssh "$node" "echo server.$id=$ip:2888:3888 | sudo tee -a /etc/zookeeper/conf/zoo.cfg"
    id=$(expr $id + 1)
  done
}

set_mesos_zk() {
  declare node="$1"
  local url=zk://$(sed -e 's/$/:2181/g' /home/ubuntu/masters | paste -s -d",")/mesos
  ssh "$node" "echo $url | sudo tee /etc/mesos/zk"
}

set_mesos_master_quorum() {
  declare node="$1"
  local nodes=$(wc -l < /home/ubuntu/masters)
  local quorum=$(((nodes / 2) + (nodes % 2 > 0)))
  ssh "$node" "echo $quorum | sudo tee /etc/mesos-master/quorum"
}

set_mesos_master_hostname() {
  declare node="$1" public_dns="$2"
  ssh "$node" "echo $public_dns | sudo tee /etc/mesos-master/hostname"
}

set_consul_master() {
  declare node="$1"
  local nodes=$(wc -l < /home/ubuntu/masters)

  ssh "$node" "echo '{\"ui_dir\": \"/opt/consul-ui\", \"server\": true, \"bootstrap_expect\": ${nodes}, \"service\": {\"name\": \"consul\", \"tags\": [\"consul\", \"bootstrap\"]}}' >/etc/consul.d/bootstrap.json"
}

set_consul_atlas() {
  declare node="$1"
  declare atlas_token="$2"
  declare atlas_infrastructure="$3"

  ssh "$node" "echo '{\"client_addr\": \"0.0.0.0\", \"atlas_join\": true, \"atlas_token\": \"${atlas_token}\", \"atlas_infrastructure\": \"${atlas_infrastructure}\" }' >/etc/consul.d/atlas.json"
}

set_mesos_slave_hostname() {
  declare node="$1" public_dns="$2"
  ssh "$node" "echo $public_dns | sudo tee /etc/mesos-slave/hostname"
}

register_service() {
  declare node="$1" service="$2"
  ssh "$node" sudo rm -f /etc/init/"$service".override
  restart_service "$node" "$service"
}

restart_service() {
  declare node="$1" service="$2"
  ssh "$node" sudo service "$service" restart
}
