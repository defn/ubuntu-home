Vagrant.configure("2") do |config|
  config.ssh.shell = "bash"
  config.ssh.username = "ubuntu"
  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.keys_only = false

  config.vm.provider "docker" do |v, override|
    v.image = "docker.nih/block:#{Dir.pwd.split("/")[-1]}"
    v.has_ssh = true
    v.ports = [ ":2222" ]

    override.vm.synced_folder '/data', '/data'
    override.vm.synced_folder '/config', '/config'

    override.ssh.guest_port = "2222"
  end
end
