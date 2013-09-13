#!/bin/bash

EXIT_CODE=0

# Install Chef\n",
curl -L https://www.opscode.com/chef/install.sh | bash || {
  echo "[ERROR] Can't install Chef Client due to error above. Exiting."
  exit 1
}

# install git, pip
apt-get update
apt-get install -y git python-pip || {
  echo "[ERROR] Exit due to error above."
  exit 1
}

echo "[INFO] Installing AWS command line tool"
pip install awscli

# Enable aws-cli tab completion for bash
# The aws-cli package includes a very useful command completion feature.
# This feature is not automatically installed. Configure it manually
complete -C aws_completer aws

echo "[INFO] Installing AWS cloud-formation init scripts"
# Used to send signal about finishing server setup.
pip install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

echo "[INFO] Installing Ohai AWS CloudFormation plugin"
# Once installed, you can define attributes in your template as follows:
#  "Resources" : {
#    "ChefClient": {
#      "Type": "AWS::EC2::Instance",
#      "Metadata" : {
#        "Chef" : {
#          "my_app" : {
#            "user" : "dbuser",
#            "password" : "pass"
#          }}}},
# Your Chef recipes can then reference the metadata as follows:
#   user => node['cfn']['my_app']['user']
#   password => node['cfn']['app']['password']
OHAI_VERSION="`/opt/chef/bin/gem list ohai | grep ohai | awk -F\( '{print $2}' | sed 's/)//'`"
GEM_BASE_DIR="`/opt/chef/bin/gem list -d ohai | grep "Installed at:" | awk '{print $3}'`"
CFN_OHAI_PLUGIN="${GEM_BASE_DIR}/gems/ohai-${OHAI_VERSION}/lib/ohai/plugins/cfn.rb"
wget -O  "$CFN_OHAI_PLUGIN" https://s3.amazonaws.com/cloudformation-examples/cfn.rb || {
  echo "[ERROR] Can't install Ohai aws cloud formation plugin. "
  exit 1
}
chmod 644 "$CFN_OHAI_PLUGIN"

