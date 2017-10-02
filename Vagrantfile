# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "debian/contrib-jessie64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # forward the default rails development port
  config.vm.network "forwarded_port", guest: 12765, host: 12765, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name = "isk-dev"
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    #
    # Customize the amount of memory on the VM:
    # vb.memory = "1024"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    # Add jessie-backports for inkscape
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
    apt-get update
    apt-get install -y gnupg2 redis-server memcached imagemagick postgresql postgresql-client libpq-dev rrdtool librrd4 librrd-dev git curl nodejs
    apt-get -t jessie-backports install -y inkscape graphviz
    # Create postgresql user and database
    su postgres -c "psql -c \\"CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant'\\" "
    su postgres -c "createdb -E UTF8 --locale=en_US.UTF-8 -O vagrant isk_development"
    su postgres -c "createdb -E UTF8 --locale=en_US.UTF-8 -O vagrant isk_test"
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # Install rvm and ruby
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
    rvm requirements
	
    # Install rubygems for ISK
    cd /vagrant
    rvm install 2.3.3
    rvm use 2.3.3
    rvm gemset create isk
    rvm gemset use isk
    gem install bundler
    bundle install

    # Setup the database
    cp /vagrant/config/database.yml.example /vagrant/config/database.yml
    rake db:schema:load
    rake db:seed
    rake isk:secrets
  SHELL
end
