# Create security groups within your VPC

require 'aws-sdk'
require 'net/http'

# Replace with your own values or use ENV variables
AWS.config(
  :access_key_id => 'XXX',
  :secret_access_key => 'XXX')

(security_group_name, vpc) = ARGV
unless security_group_name && vpc 
  puts "Usage: aws_security_groups.rb <security_group_name> <VPC>"
  exit 1
end

begin
  ec2 = AWS::EC2.new
  security_group = ec2.security_groups
  sg = security_group.create(security_group_name, :vpc => vpc)
end