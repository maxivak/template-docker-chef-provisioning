echo "---------- Provisioning Container"

# copy provision files to container
docker cp cookbooks nginx:/opt/provision/

# provision container
docker cp config/config.json nginx:/opt/provision/config/
docker exec nginx bash -c 'cd /opt/provision/ && chef-client -z -j /opt/provision/config/config.json -o recipe[nginx::ex1]'

