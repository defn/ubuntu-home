require 'socket'

ci_script = "#{ENV['_limbo_home']}/script/cloud-init-bootstrap"

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash"
  config.ssh.username = "ubuntu"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.keys_only = false

  config.vm.provider "docker" do |v, override|
    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder '/data', '/data'
    override.vm.synced_folder '/config', '/config'

    override.ssh.guest_port = "2222"
    override.vm.network "forwarded_port", id: "ssh", disabled: true, host: 2222, guest: 2222

    v.docker_network = "ubuntu_default"
    v.image = "docker.nih/block:#{Dir.pwd.split("/")[-1]}"
    v.has_ssh = true
  end

  config.vm.provider "virtualbox" do |v, override|
    override.vm.box = ENV['SOURCE_NAME'] ? ENV['SOURCE_NAME'] : "block:ubuntu"

    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder '/data', '/data', type: "nfs"
    override.vm.synced_folder '/config', '/config', type: "nfs"

    override.vm.provision "shell", path: ci_script, args: [], privileged: true

    override.vm.network "private_network", ip: '172.28.128.10', nic_type: 'virtio'

    v.memory = 1024
    v.cpus = 2

    v.customize [ 
      'storageattach', :id, 
      '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, 
      '--type', 'dvddrive', '--medium', "#{ENV['_base_home']}/cidata.vagrant.iso"
    ]
  end

  config.vm.provider "aws" do |v, override|
    override.vm.box = ENV['SOURCE_NAME'] ? ENV['SOURCE_NAME'] : "block:ubuntu"

    override.vm.synced_folder ENV['HOME'], '/vagrant', disabled: true
    override.vm.synced_folder '/data/cache/nodist', '/data/cache/nodist', type: "rsync", rsync__args: [ "-ia" ]
    override.vm.synced_folder ENV['AWS_SYNC'], ENV['AWS_SYNC'], type: "rsync", rsync__args: [ "-ia" ] if ENV['AWS_SYNC']

    override.vm.provision "shell", path: ci_script, args: [], privileged: true

    v.iam_instance_profile_name = ENV['AWS_IAM'] || "id-iam-role-not-set"
    v.ami = ENV['AWS_AMI'] || 'id-aws-ami-not-set'
		v.tags = {
			"ManagedBy" => "vagrant",
			"Env" => "build",
			"App" => "vagrant",
      "Service" => Dir.pwd.split("/")[-1]
		}
  end

  (0..0).each do |d|
    config.vm.define "#{Socket.gethostname}-v#{d}", primary: (d == 0), autostart: (d == 0) do |dcker|
    end
  end
end
