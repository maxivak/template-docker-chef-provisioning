require 'chef/provisioning'

# settings
app_data_dir = node['base']['dir_data']
docker_volumes = node['docker']['volumes']
docker_ports = node['docker']['ports']


docker_volumes.each do |d|
  directory "#{app_data_dir}#{d}" do
    mode '0775'
    recursive true
    action :create
  end
end


### docker container
with_driver 'docker'
machine 'nginx' do
  tag '0.1'

  #action :create

  recipe 'nginx::create'

  #chef_environment chef_env

  # attributes
  node.keys.each do |k|
    attribute k, node[k]
  end


  machine_options docker_options: {
      base_image: node['base']['base_image'],
      privileged: true,
      :ports => docker_ports,
      :volumes => docker_volumes.map{|d| "#{app_data_dir}#{d}:#{d}"}
  }

end

