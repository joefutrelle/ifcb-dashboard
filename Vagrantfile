Vagrant.configure("2") do |config|
  config.vm.box = "velocity42/xenial64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory="2048"
  end
  config.vm.network :forwarded_port, host: 8888, guest: 8888
end

