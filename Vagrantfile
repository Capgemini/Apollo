# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

base_dir = File.expand_path(File.dirname(__FILE__))
conf = YAML.load_file(File.join(base_dir, "vagrant.yml"))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # if you want to use vagrant-cachier,
  # please install vagrant-cachier plugin.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.enable :apt
  end

  config.vm.box = "capgemini/mesos"
  config.vm.box_version = conf['mesos_version']

  # Mesos master nodes
  master_n = conf['master_n']
  master_infos = (1..master_n).map do |i|
    node = {
      :zookeeper_id    => i,
      :quorum          => (master_n.to_f/2).ceil,
      :hostname        => "master#{i}",
      :ip              => conf['master_ipbase'] + "#{10+i}",
      :mem             => conf['master_mem'],
      :cpus            => conf['master_cpus'],
    }
  end
  zookeeper = "zk://"+master_infos.map{|master| master[:ip]+":2181"}.join(",")+"/mesos"
  zookeeper_conf = master_infos.map{|master| "server.#{master[:zookeeper_id]}"+"="+master[:ip]+":2888:3888"}.join("\n")
  consul_join = master_infos.map{|master| master[:ip]}.join(" ")

  # Mesos slave nodes
  slave_n = conf['slave_n']
  slave_infos = (1..slave_n).map do |i|
    node = {
      :hostname => "slave#{i}",
      :ip => conf['slave_ipbase'] + "#{10+i}",
      :mem => conf['slave_mem'],
      :cpus => conf['slave_cpus'],
    }
  end

  master_infos.flatten.each_with_index do |node|
    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.hostname = node[:hostname]
        override.vm.network :private_network, :ip => node[:ip]
        override.vm.provision :hosts

        vb.name = 'vagrant-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]

        $master = <<SCRIPT
        echo #{node[:zookeeper_id]} | sudo tee /etc/zookeeper/conf/myid
        echo #{node[:quorum]} | sudo tee /etc/mesos-master/quorum
        echo vagrant | sudo tee /etc/mesos-master/cluster
        echo #{node[:ip]} | sudo tee /etc/mesos-master/ip
        echo #{zookeeper} | sudo tee /etc/mesos/zk
        echo "#{zookeeper_conf}" | sudo tee -a /etc/zookeeper/conf/zoo.cfg
        echo '{\"bind_addr\": \"#{node[:ip]}\", \"advertise_addr\": \"#{node[:ip]}\", \"client_addr\": \"0.0.0.0\", \"ui_dir\": \"/opt/consul-ui\", \"datacenter\": \"vagrant\", \"server\": true, \"bootstrap_expect\": #{master_n}, \"service\": {\"name\": \"consul\", \"tags\": [\"consul\", \"bootstrap\"]}}' >/etc/consul.d/bootstrap.json
        echo 'CONSUL_JOIN=\"#{consul_join}\"' > /etc/service/consul-join
        sudo rm -f /etc/init/zookeeper.override
        sudo rm -f /etc/init/mesos-master.override
        sudo rm -f /etc/init/marathon.override
        sudo rm -f /etc/init/consul.override
        sudo rm -f /etc/init/consul-join.override
        sudo service zookeeper restart
        sudo service mesos-master start
        sudo service marathon restart
        sudo service consul restart
SCRIPT

        override.vm.provision "shell", inline: $master
      end
    end
  end

  slave_infos.flatten.each_with_index do |node|
    config.vm.define node[:hostname] do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.hostname = node[:hostname]
        override.vm.network :private_network, :ip => node[:ip]
        override.vm.provision :hosts

        vb.name = 'vagrant-mesos-' + node[:hostname]
        vb.customize ["modifyvm", :id, "--memory", node[:mem], "--cpus", node[:cpus] ]

        $slave = <<SCRIPT
        echo #{zookeeper} | sudo tee /etc/mesos/zk
        echo #{node[:ip]} | sudo tee /etc/mesos-slave/ip
        echo '{\"bind_addr\": \"#{node[:ip]}\", \"advertise_addr\": \"#{node[:ip]}\", \"datacenter\": \"vagrant\", \"client_addr\": \"0.0.0.0\"}' >/etc/consul.d/slave.json
        echo 'CONSUL_JOIN=\"#{consul_join}\"' > /etc/service/consul-join
        sudo rm -f /etc/init/mesos-slave.override
        sudo rm -f /etc/init/docker.override
        sudo rm -f /etc/init/consul.override
        sudo rm -f /etc/init/consul-join.override
        sudo service mesos-slave restart
        sudo service docker restart
        sudo service consul restart
SCRIPT

        override.vm.provision "shell", inline: $slave
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
