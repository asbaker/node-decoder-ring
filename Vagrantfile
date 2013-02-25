# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # TODO this should be chef'ed
  # run this after you install and then run nvm install (your version here)
  # wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh"
  config.vm.provision :shell, :inline => "apt-get install curl git build-essential -y"
end
