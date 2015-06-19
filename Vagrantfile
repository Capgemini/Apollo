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

  ansible_groups = {
    "mesos_masters"              => ["master1", "master2", "master3"],
    "mesos_slaves"               => ["slave1"],
    "all:children"               => ["mesos_masters", "mesos_slaves", "load_balancers"],
    "load_balancers:children"    => ["mesos_slaves"],
    "zookeeper_servers:children" => ["mesos_masters"],
    "consul_servers:children"    => ["mesos_masters"],
    "weave_servers:children"     => ["mesos_masters", "mesos_slaves", "load_balancers"],
    "vagrant:children"           => ["mesos_masters", "mesos_slaves", "load_balancers"],
  }

  # Mesos master nodes
  master_infos = (1..3).map do |i|
    node = {
      :zookeeper_id    => i,
      :hostname        => "master#{i}",
      :ip              => conf["master#{i}_ip"],
      :mem             => conf['master_mem'],
      :cpus            => conf['master_cpus'],
    }
  end
  mesos_zk_url = "zk://"+master_infos.map{|master| master[:ip]+":2181"}.join(",")+"/mesos"
  zookeeper_conf = master_infos.map{|master|
    "server.#{master[:zookeeper_id]}"+"="+master[:ip]+":2888:3888"}.join(" ")
  consul_join = master_infos.map{|master| master[:ip]}.join(" ")
  consul_retry_join = master_infos.map{|master|
    "\"#{master[:ip]}\""}.join(", ")

  # Mesos slave nodes
  slave_n = conf['slave_n']
  slave_infos = (1..slave_n).map do |i|
    node = {
      :hostname => "slave#{i}",
      :ip => conf["slave#{i}_ip"],
      :mem => conf['slave_mem'],
      :cpus => conf['slave_cpus'],
    }
  end

  master_infos.flatten.each_with_index do |node|
    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, machine|
        machine.vm.hostname = node[:hostname]
        machine.vm.network :private_network, :ip => node[:ip]

        vb.name = 'vagrant-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]
      end
    end
  end

  slave_infos.flatten.each_with_index do |node|
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
              consul_retry_join: consul_retry_join
            }
          end
        end
      end
    end
  end

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
