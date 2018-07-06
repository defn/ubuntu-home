require 'socket'

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash"
  config.ssh.username = ENV.fetch("VAGRANT_USERNAME","ubuntu")
  config.ssh.forward_agent = true
  config.ssh.insert_key = true
  config.ssh.keys_only = false

  config.vm.provider "virtualbox" do |v, override|
    v.linked_clone = true
    v.memory = 1024
    v.cpus = 2

    override.vm.box = ENV.fetch("VAGRANT_BOX","imma/ubuntu-18.04")

    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder ENV['DATA'], '/data'

    #override.vm.provision "shell", path: "setup-vagrant", args: [], privileged: true

    #v.customize [ 'storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'dvddrive', '--medium', "#{ENV['_base_home']}/cidata.vagrant.iso" ]
  end
end
