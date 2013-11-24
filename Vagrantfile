# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
    aws.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    aws.keypair_name = ENV["EC2_KEY_NAME"]
    aws.instance_type = "c1.xlarge"
    aws.region = "ap-northeast-1"
    aws.terminate_on_shutdown = true
    aws.ami = ENV["EC2_AMI_ID"]

    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = ENV["EC2_KEY_NAME"]
  end
end
