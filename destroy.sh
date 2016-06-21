# remove all
chef-client -z -j config/config.json destroy.rb

docker rm -f chef-converge.nginx
docker rm -f nginx
