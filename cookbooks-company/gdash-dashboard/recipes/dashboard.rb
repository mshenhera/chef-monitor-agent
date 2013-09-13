
search_attribute = node['gdash-dashboard']['sensu-client-attribute']
sensu_clients_list = search(:node, "#{search_attribute}:true")

sensu_clients_list.each do |sensu_client|

  directory "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}" do
    action :create
    recursive true
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/dash.yaml"
    source 'dash.yaml.erb'
    variables({
      :server => sensu_client.name
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/cpu.graph"
    source 'cpu.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/load.graph"
    source 'load.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/memory.graph"
    source 'memory.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/network.graph"
    source 'network.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/disk_usage.graph"
    source 'disk_usage.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end

  template sensu_client.name do
    action :create
    path "#{node['gdash-dashboard']['dashboard']['home']}/system-metrics/#{sensu_client.name}/disk_io.graph"
    source 'disk_io.graph.erb'
    variables({
      :hostname => sensu_client.hostname
    })
  end
end
