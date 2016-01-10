# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'fileutils'

base_dir = File.expand_path(File.dirname(__FILE__))
conf = YAML.load_file(File.join(base_dir, "vagrant.yml"))
groups = YAML.load_file(File.join(base_dir, "ansible-groups.yml"))

CONFIG_HELPER = File.join(base_dir, "vagrant_helper.rb")
CLOUD_CONFIG_PATH = File.join(base_dir, "user-data")

if File.exist?(CONFIG_HELPER)
  require CONFIG_HELPER
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.8.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box              = "coreos-%s" % conf['coreos_update_channel']
  config.vm.box_version      = ">= %s" % conf["coreos_#{conf['coreos_update_channel']}_min_version"]
  config.vm.box_url          = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % conf['coreos_update_channel']

  if Vagrant.has_plugin?('vagrant-vbguest') then
    config.vbguest.auto_update = false
  end

  config.hostmanager.enabled = false

  config.vm.provider :virtualbox do |vb|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    vb.check_guest_additions = false
    vb.functional_vboxsf     = false
  end

  config.ssh.insert_key = false

  # Common ansible groups.
  ansible_groups = groups['ansible_groups']
  # We need to use a custom python interpreter for CoreOS because there is no
  # python installed on the system.
  ansible_groups["all:vars"] = {
    "ansible_python_interpreter" => "\"PATH=/home/core/bin:$PATH python\""
  }
  ansible_groups["mesos_masters"] = []

  masters_conf = conf['masters']
  masters_n    = masters_conf['ips'].count
  master_infos = []

  # Mesos slave nodes
  slaves_conf = conf['slaves']
  ansible_groups["mesos_slaves"] = []
  slave_n = slaves_conf['ips'].count

  # etcd discovery token
  total_instances = slave_n + masters_n
  etcd_discovery_token(total_instances)

  # Mesos master nodes
  (1..masters_n).each { |i|

    ip = masters_conf['ips'][i - 1]
    node = {
      :zookeeper_id => i,
      :hostname     => "master#{i}",
      :ip           => ip,
      :mem          => masters_conf['mem'],
      :cpus         => masters_conf['cpus'],
    }

    master_infos.push(node)

    # Add the node to the correct ansible group.
    ansible_groups["mesos_masters"].push(node[:hostname])

    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, machine|
        machine.vm.hostname = node[:hostname]
        machine.vm.network :private_network, :ip => node[:ip]

        vb.name = 'coreos-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]
      end
    end
  }

  # zookeeper_peers e.g. 172.31.1.11:2181,172.31.1.12:2181,172.31.1.13:2181
  zookeeper_peers   = master_infos.map{|master| master[:ip]+":2181"}.join(",")
  # zookeeper_conf e.g. server.1=172.31.1.11:2888:3888 server.2=172.31.1.12:2888:3888 server.3=172.31.1.13:2888:3888
  zookeeper_conf    = master_infos.map{|master| "server.#{master[:zookeeper_id]}"+"="+master[:ip]+":2888:3888"}.join(" ")
  # consul_js e.g. 172.31.1.11 172.31.1.12 172.31.1.13
  consul_join       = master_infos.map{|master| master[:ip]}.join(" ")
  # consul_retry_join e.g. "172.31.1.11", "172.31.1.12", "172.31.1.13"
  consul_retry_join = master_infos.map{|master| "\"#{master[:ip]}\""}.join(", ")

  # Ansible variables
  ansible_extra_vars = {
    zookeeper_peers: zookeeper_peers,
    zookeeper_conf: zookeeper_conf,
    consul_join: consul_join,
    consul_retry_join: consul_retry_join,
    mesos_master_quorum: conf['mesos_master_quorum'],
    consul_bootstrap_expect: conf['consul_bootstrap_expect'],
    ansible_python_interpreter: 'PATH=/home/core/bin:$PATH python'
  }
  # Apollo environment variables
  apollo_vars = get_apollo_variables(ENV)
  # Add apollo variables to ansible ones
  ansible_extra_vars.merge!(apollo_vars)

  (1..slave_n).each { |i|

    ip = slaves_conf['ips'][i - 1]
    node = {
      :hostname => "slave#{i}",
      :ip       => ip,
      :mem      => slaves_conf['mem'],
      :cpus     => slaves_conf['cpus'],
    }

    # Add the node to the correct ansible group.
    ansible_groups["mesos_slaves"].push(node[:hostname])

    # Bootstrap the machines for CoreOS first
    if File.exist?(CLOUD_CONFIG_PATH)
      config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
      config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
    end

    config.vm.provision :hostmanager

    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, machine|
        machine.vm.hostname = node[:hostname]
        machine.vm.network :private_network, :ip => node[:ip]

        vb.name = 'coreos-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]

        # We invoke ansible on the last slave with ansible.limit = 'all'
        # this runs the provisioning across all masters and slaves in parallel.
        if node[:hostname] == "slave#{slave_n}"

          machine.vm.provision :ansible do |ansible|
            ansible.playbook = "site.yml"
            unless ENV['ANSIBLE_LOG'].nil? || ENV['ANSIBLE_LOG'].empty?
             ansible.verbose = "#{ENV['ANSIBLE_LOG'].delete('-')}"
            end
            ansible.groups     = ansible_groups
            ansible.limit      = 'all'
            ansible.extra_vars = ansible_extra_vars
          end
        end
      end
    end
  }
end
