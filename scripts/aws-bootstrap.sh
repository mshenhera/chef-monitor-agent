#!/bin/bash

EXIT_CODE=0

# Install Chef\n",
curl -L https://www.opscode.com/chef/install.sh | bash || {
  echo "Can't install Chef Client due to error above. Exiting."
  exit 1
}

# install git
apt-get update
apt-get install -y git || {
  echo "[ERROR] Exit due to error above."
  exit 1
}

# Downloa chef-solo configuration.
if [[ -d '/etc/chef-solo' ]]; then
  pushd /etc/chef-solo
  git fetch 
  git pull
  popd
else
  git clone https://github.com/mshenhera/ChefSolo.git /etc/chef-solo
fi

# Setup Chef Client
chef-solo -c /etc/chef-solo/chef-solo.rb -j /etc/chef-solo/default-node.json || {
  echo "Failed to initialize host via chef solo"
  exit 1
}

# Setup server using Chef\n",
chef-client -j /etc/chef/first-boot.json || {
  echo "Failed to initialize host via chef client" >> /var/log/bootstrap.log 2>&1
  EXIT_CODE=1
}
