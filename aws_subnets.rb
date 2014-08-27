# Add a subnet to your VPC

require 'aws-sdk'
require 'net/http'

# Replace with your own values or use ENV variables
AWS.config(
  :access_key_id => 'XXX',
  :secret_access_key => 'XXX')


# Need to add DHCP Option Sets

(subnet_name, cidr, vpc, az) = ARGV
unless subnet_name && cidr && vpc && az
  puts "Usage: aws_subnets.rb <SUBNET_NAME> <CIDR> <VPC> <AZ>"
  exit 1
end

begin
  ec2 = AWS::EC2.new
  subnets = ec2.vpcs[vpc].subnets
  subnet = subnets.create(cidr,{:vpc => vpc, :availability_zone => az})
  puts "#{subnet.subnet_id}"
  # have to sleep for a couple seconds to let the subnet propagate at amazon before tagging it
  sleep 2
  ec2.tags.create(subnet, 'Name',:value => subnet_name)
end
