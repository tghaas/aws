# Add ingress rules to AWS security groups

# source_security_group_name is the security group we are modifying
# dest_group_name is the security group is the source of the traffic

require 'aws-sdk'
require 'net/http'

# Replace with your own values or use ENV variables
AWS.config(
  :access_key_id => 'XXX',
  :secret_access_key => 'XXX')

(source_security_group_name, dest_group_name, proto, port) = ARGV
unless source_security_group_name && dest_group_name && proto && port 
  puts "Usage: aws_security_group_permissions.rb <source_security_group_name> <dest_group_name> <proto> <port>"
  exit 1
end

begin
  ec2 = AWS::EC2.new
  # Get the group_id when given only the group_name
  sg = ec2.security_groups.filter('group-name', dest_group_name).each do | group|
    $dsg = group.id
  end
  sg = nil
  # Add the security rule:
  sg = ec2.security_groups.filter('group-name', source_security_group_name).each do | group|
	group.authorize_ingress(proto, port, { :group_id => $dsg})
  end
end