
include_recipe 'sensu::default'

package 'git' do
  action :install
end

gem_package 'sensu-plugin' do
  action :install
  options('--no-rdoc --no-ri')
end

git 'sensu-community-plugins' do
  repository 'https://github.com/sensu/sensu-community-plugins.git'
  destination '/etc/sensu/sensu-community-plugins'
  reference 'master'
  action :sync
end

sensu_handler 'graphite_amqp' do
  type 'amqp'
  exchange(
    :type => 'topic',
    :name => 'metrics',
    :durable => 'true'
  )
  mutator 'only_check_output'
end

sensu_check 'metrics_load' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/load-metrics.rb'
  handlers ['graphite']
  interval 30
  standalone true
end

sensu_check 'metrics_memory' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/memory-metrics.rb'
  handlers ['graphite']
  interval 30
  standalone true
end

sensu_check 'metrics_cpu' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/cpu-pcnt-usage-metrics.rb'
  handlers ['graphite']
  interval 30
  standalone true
end

sensu_check 'metrics_cpu_usage' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/cpu-usage-metrics.sh'
  handlers ['graphite']
  interval 30
  standalone true
end

sensu_check 'metrics_interface' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/interface-metrics.rb'
  handlers ['graphite']
  interval 30
  standalone true
end

sensu_check 'metrics_disk_usage' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/disk-usage-metrics.rb'
  handlers ['graphite']
  interval 60
  standalone true
end

sensu_check 'metrics_disk' do
  type 'metric'
  command '/etc/sensu/sensu-community-plugins/plugins/system/disk-metrics.rb'
  handlers ['graphite']
  interval 60
  standalone true
end

sensu_client node.name do
  if node.has_key?('cloud')
    address node['cloud']['local_ipv4'] || node['ipaddress']
  else
    address node['ipaddress']
  end
  subscriptions ['default']
end

include_recipe 'sensu::client_service'

