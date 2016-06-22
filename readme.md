# Build and provision Docker container with Chef
Example of building and provisioning Docker container with Chef provisioning.

## Problem

We have a workstation with Chef and cookbooks and we want to manage Docker container locally.
We want to 
* create and run Docker container locally;
* provision a Docker container by running a Chef recipe in a container.


## Solution
We will use Chef provisioning to create a Docker container.

Workflow:
* build image using Chef provisioning or use existing image
* create and run Docker container running 'chef-client -z' on Workstation
* update running container with Chef 


Workstation:
* has ChefDK installed


Settings:
* `config/config.json` - attributes used to create and provision container
* `container.rb` - settings for Docker container


Create container:
```
chef-client -z -j config/config.json container.rb
```

 
Provision container:

```
# copy provision files to container
docker cp ../cookbooks nginx:/opt/provision/

# provision container
docker cp ../config/config.json nginx:/opt/gex/config/
docker exec nginx bash -c 'cd /opt/gex/ && chef-client -z -j /opt/provision/config/config.json -o recipe[nginx::provision]'
```


* Read more about provisioning Docker container with chef-client - https://gist.github.com/maxivak/167e46b3570a834231be7bbeefe9243a 
 
## Workstation:

* install ChefDK


* install gems for Chef provisioning
```
chef gem install chef-provisioning
chef gem install chef-provisioning-docker

chef gem install docker
chef gem install docker-api
```

* Setup workstation

* It assumes we have chef-repo on the workstation. This chef-repo contains common cookbooks.

* Also we can have custom cookbooks.

* Directory structure

```
/path/to/project/
    |__ .chef/ - directory with settings for knife
        |__ knife.rb - settings for knife
    |__ cookbooks/ - directory with cookbooks for the machine
    |_  container.rb
    |_ destroy.rb
    
```

* chef-repo - directory with cookbooks somewhere on the workstation

```
/path/to/chef-repo
    |_ cookbooks
    ...
    
```

* edit `./chef/knife.rb`:

```
log_level                :info

root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

# specify path to your cookbooks
cookbook_path [ File.join(root, '../cookbooks'), '/another/path/to/your/chef-repo/cookbooks' ]
```

include paths to cookbooks from chef-repo and to cookbooks in our project.



# Create and run a new container

* edit `config/config.json` with settings for the container
* edit `container.rb` for additional settings for running Docker container


* run on Workstation to create a container named 'nginx':
```
chef-client -z -j config/config.json container.rb
```

* 'config.json' consists of settings for the node (container)
```
{

  "base":{
    # base directory for shared volumes 
    "dir_data": "/disk3/data/containers/nginx"  
  },
  
  # docker options
  "docker": {
    "ports": ["8080:80"],
    "volumes": ["/var/www/html", "/etc/nginx/conf.d", "/var/log/nginx"]
  },
  
  # specific options for the application
  "nginx":{
    "sitename": "site1.com",
    # place your attributes here
  }

}
```

* This example creates container for Nginx from base image 'nginx:1.10'.


* If you want to build your own Docker image with Chef - read below "Build Docker image with Chef".


* To destroy the container run this script:
```
chef-client -z -j config/config.json destroy.rb
```


# Provision a running container

We have a running Docker container and want to modify its state with Chef provisioning.

* Create a chef recipe `cookbooks/nginx/recipes/ex1.rb`.

Include everything you want to do with the container assuming that this script will be run from inside the container.


* Run provision:
```
docker cp ../cookbooks nginx:/opt/provision/
docker cp config/config.json nginx:/opt/provision/config/

docker exec nginx bash -c 'cd /opt/provision/ && chef-client -z -j /opt/provision/config/config.json -o recipe[nginx::ex1]'
```

This will copy cookbooks and config.json to the container and then run chef-client from inside the container.


Workflow:
* it will copy all cookbooks from `cookbooks` directory to the container
If you need more cookbooks, copy them as well.

* it runs `chef-client -z` in local mode from inside the container.


# Build Docker image with Chef

