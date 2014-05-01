# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |_c|
  
  _c.vm.define :flxweb1 do |config|
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.network :public_network
    config.vm.hostname = "flxweb"
    config.vm.synced_folder ".", "/vagrant", :extra => "dmode=777,fmode=777"
    
    config.vm.provider :virtualbox do |v|
        v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end
    
    config.vm.provider :aws do |aws, override|
        aws.access_key_id = "ACCESS KEY"
        aws.secret_access_key = "SHHHHHH SECRET"
        aws.keypair_name = "KEYPAIR"
        
        aws.security_groups = "SECURITY GROUPS"

        aws.ami = "AMI ID"

        override.ssh.username = "SSH USERNAME"
        override.ssh.private_key_path = "SSH KEYPAIR"
    end
    
	config.vm.provision :shell, :path => "moodlesetup.sh"
  end
  
end
