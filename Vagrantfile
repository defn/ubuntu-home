require 'socket'

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash"
  config.ssh.username = "ubuntu"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.keys_only = false

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = "bento/ubuntu-18.04"

    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder ENV['DATA'], '/data', type: "nfs"

    #override.vm.provision "shell", path: ci_script, args: [], privileged: true

    override.vm.network "private_network", ip: '172.28.128.10', nic_type: 'virtio'

    v.memory = 1024
    v.cpus = 2

    #v.customize [ 'storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'dvddrive', '--medium', "#{ENV['_base_home']}/cidata.vagrant.iso" ]
  end
end
