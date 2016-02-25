Vagrant.require_version ">= 1.3.5"

Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |v| 
  	v.memory = 2048
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate//vagrant", "1"]
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8443, host: 8443

  config.vm.box = "ubuntu/vivid64"
  
  config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"
  config.vm.provision "docker"
  config.vm.provision "shell", path: "./provision.sh"

  config.vm.synced_folder ".", "/home/vagrant/engine"
end