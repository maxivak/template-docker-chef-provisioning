['/opt/provision/config'].each do |d|
  directory d do
    recursive true
    action :create
  end

end
