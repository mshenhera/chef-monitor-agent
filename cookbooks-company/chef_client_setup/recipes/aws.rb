
# Installing Ohai AWS CloudFormation plugin

# Installing packages required by bootstrap script
%(python-pip).each do |pkg|
  package pkg do
    action :install
  end
end

# Installing AWS command line tool
python_pip 'awscli' do
  action :upgrade
end

# Enable aws-cli tab completion for bash
# The aws-cli package includes a very useful command completion feature.
# This feature is not automatically installed. Configure it manually
exec 'Enable_aws-cli_tab_completion' do
  command 'complete -C aws_completer aws'
  not_if 'complete | grep -i aws_completer > /dev/null'
end

# Installing AWS cloud-formation init scripts.
# Used to send signal about finishing server setup.
python_pip 'aws-cfn-bootstrap' do
  action :upgrade
  package_name 'https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz'
end

# Install /etc/chef/client.rb

info "Installing Ohai AWS CloudFormation plugin"
OHAI_VERSION="`gem list ohai | grep ohai | awk -F\( '{print $2}' | sed 's/)//'`"
GEM_BASE_DIR="`gem list -d ohai | grep "Installed at:" | awk '{print $3}'`"
CFN_OHAI_PLUGIN="${GEM_BASE_DIR}/gems/ohai-${OHAI_VERSION}/lib/ohai/plugins/cfn.rb"
wget -O  "$CFN_OHAI_PLUGIN" https://s3.amazonaws.com/cloudformation-examples/cfn.rb || {
  error "Can't install Ohai aws cloud formation plugin. "
  exit 1
}


