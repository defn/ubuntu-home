require "net/ssh"

module Net::SSH
  class << self
    alias_method :old_start, :start

    def start(host, username, opts)
      opts[:keys_only] = false
      self.old_start(host, username, opts)
    end
  end
end

Vagrant.configure("2") do |config|
  module Vagrant
    module Util
      class Platform
        class << self
          def solaris?
            true
          end
        end
      end
		end
	end
end

Vagrant.configure("2") do |config|
  shome=File.expand_path("..", __FILE__)

  config.ssh.shell = "bash"
  config.ssh.username = "ubuntu"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = "block:ubuntu"

    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder '/data', '/data', type: "nfs"
    override.vm.synced_folder '/config', '/config', type: "nfs"

    override.vm.provision "shell", path: "#{shome}/script/cloud-init-wait", args: [], privileged: false

    v.linked_clone = true
    v.memory = 1024
    v.cpus = 2

    v.customize [ 'modifyvm', :id, '--nictype1', 'virtio' ]
    v.customize [ 'modifyvm', :id, '--paravirtprovider', 'kvm' ]
    v.customize [ 'modifyvm', :id, '--cableconnected1', 'on' ]
    v.customize [ 'modifyvm', :id, '--cableconnected2', 'on' ]

    v.customize [ 
      'storageattach', :id, 
      '--storagectl', 'SATA Controller', 
      '--port', 1, 
      '--device', 0, 
      '--type', 'dvddrive', 
      '--medium', "#{shome}/cidata.iso"
    ]
    v.customize [
      'storagectl', :id,
      '--name', 'SATA Controller',
      '--hostiocache', 'on'
    ]
  end

  config.vm.define "default", primary: true do |machine|
    machine.vm.network "private_network", nic_type: 'virtio', ip: '172.28.128.11'
  end

  config.vm.define "k8s-master", autostart: false do |machine|
    machine.vm.network "private_network", nic_type: 'virtio', ip: '172.28.128.12'
  end

  config.vm.define "k8s-node1", autostart: false do |machine|
    machine.vm.network "private_network", nic_type: 'virtio', ip: '172.28.128.13'
  end

  config.vm.define "k8s-node2", autostart: false do |machine|
    machine.vm.network "private_network", nic_type: 'virtio', ip: '172.28.128.13'
  end
end
