# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu-12.04-32bit"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.synced_folder "./", "/home/vagrant/ardupilot"

  config.vm.provider "virtualbox" do |vb|
    # Allow symlinks
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/cross-compiler", "1"]

    # Otherwise the compile will go into swap, making things slow
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # TODO:
  # * Need to adjust the script to send the $ASSUME_YES env var
  # * and to be idimpotent
  # * maybe use salt?
  # config.vm.provision "shell", path: "Tools/scripts/install-prereqs-ubuntu.sh"
end

