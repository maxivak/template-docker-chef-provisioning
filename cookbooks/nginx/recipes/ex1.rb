file '/tmp/temp1.txt' do
  content 'just a test'
  mode '0775'
end

template '/var/www/html/index.html' do
  source 'index.html.erb'

  #owner 'root'
  #group 'root'
  mode '0775'
end
