log_level                :info

root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

#node_name                "provisioner"
#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

cookbook_path [ File.join(root, '../cookbooks'), '/another/path/to/your/chef-repo/cookbooks' ]


