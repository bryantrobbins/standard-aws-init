#!/bin/bash -v

host=$1
folder=$2

echo "Installing on host ${host}"

echo "Updating packages"
yum update -y

echo "Installing yum packages"
yum install -y rubygems git puppet3

echo "Installing rubygems"
gem install r10k hiera-eyaml hiera-eyaml-kms

echo "Running r10k"
pushd /root/init
/usr/local/bin/r10k deploy environment -v debug &> /var/log/puppet/r10k.log

echo "Running Puppet"
puppet apply /etc/puppet/code/environments/production/site.pp --hiera_config hiera.yaml --modulepath=/etc/puppet/code/environments/production/modules/:/etc/puppet/code/environments/production/site
popd

echo "Done with INIT."
