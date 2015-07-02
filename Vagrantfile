# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

base_dir = File.expand_path(File.dirname(__FILE__))
conf = YAML.load_file(File.join(base_dir, "vagrant.yml"))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.7.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # if you want to use vagrant-cachier,
  # please install vagrant-cachier plugin.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.enable :apt
    config.cache.scope = :box
  end

  # throw error if vagrant-hostmanager not installed
  unless Vagrant.has_plugin?("vagrant-hostmanager")
    raise "vagrant-hostmanager plugin not installed"
  end

  config.vm.box = "capgemini/apollo"
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true
  config.ssh.insert_key = false

  # Common ansible groups.
  ansible_groups = conf['ansible_groups'];

  masters_conf = conf['masters']
  masters_n = masters_conf['ips'].count
  ansible_groups["mesos_masters"] = []
  master_infos = []

  # Mesos master nodes
  (1..masters_n).each { |i|

    ip = masters_conf['ips'][i - 1]
    node = {
      :zookeeper_id    => i,
      :hostname        => "master#{i}",
      :ip              => ip,
      :mem             => masters_conf['mem'],
      :cpus            => masters_conf['cpus'],
    }

    master_infos.push(node)

    # Add the node to the correct ansible group.
    ansible_groups["mesos_masters"].push(node[:hostname])

    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, machine|
        machine.vm.hostname = node[:hostname]
        machine.vm.network :private_network, :ip => node[:ip]

        vb.name = 'vagrant-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]
      end
    end
  }

  mesos_zk_url = "zk://"+master_infos.map{|master| master[:ip]+":2181"}.join(",")+"/mesos"
  marathon_master_peers = "zk://"+master_infos.map{|master| master[:ip]+":2181"}.join(",")+"/mesos"
  marathon_zk_peers = "zk://"+master_infos.map{|master| master[:ip]+":2181"}.join(",")+"/marathon"
  chronos_zk_url = master_infos.map{|master| master[:ip]+":2181"}.join(",")
  zookeeper_conf = master_infos.map{|master|
    "server.#{master[:zookeeper_id]}"+"="+master[:ip]+":2888:3888"}.join(" ")
  consul_join = master_infos.map{|master| master[:ip]}.join(" ")
  consul_retry_join = master_infos.map{|master|
    "\"#{master[:ip]}\""}.join(", ")

  # Mesos slave nodes
  slaves_conf = conf['slaves']
  ansible_groups["mesos_slaves"] = []

  slave_n = slaves_conf['ips'].count

  (1..slave_n).each { |i|

    ip = slaves_conf['ips'][i - 1]

    node = {
      :hostname => "slave#{i}",
      :ip => ip,
      :mem => slaves_conf['mem'],
      :cpus => slaves_conf['cpus'],
    }

    # Add the node to the correct ansible group.
    ansible_groups["mesos_slaves"].push(node[:hostname])

    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, machine|
        machine.vm.hostname = node[:hostname]
        machine.vm.network :private_network, :ip => node[:ip]

        vb.name = 'vagrant-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]

        # We invoke ansible on the last slave with ansible.limit = 'all'
        # this runs the provisioning across all masters and slaves in parallel.
        if node[:hostname] == "slave#{slave_n}"
          machine.vm.provision :ansible do |ansible|
            ansible.playbook = "site.yml"
            ansible.sudo = true
            ansible.groups = ansible_groups
            ansible.limit = 'all'
            ansible.extra_vars = {
              mesos_zk_url: mesos_zk_url,
              zookeeper_conf: zookeeper_conf,
              consul_join: consul_join,
              consul_retry_join: consul_retry_join,
              marathon_master_peers: marathon_master_peers,
              marathon_zk_peers: marathon_zk_peers
            }
          end
        end
      end
    end
  }

  # If you want to use a custom `.dockercfg` file simply place it
  # in this directory.
  if File.exist?(".dockercfg")
    config.vm.provision :shell, :priviledged => true, :inline => <<-SCRIPT
      cp /vagrant/.dockercfg /root/.dockercfg
      chmod 600 /root/.dockercfg
      chown root /root/.dockercfg
    SCRIPT
  end
end
