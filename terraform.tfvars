# Application Definition
app_name        = "kopicloud" # Do NOT enter any spaces
app_environment = "test" # Dev, Test, Prod, etc

#AWS authentication variables
aws_access_key    = "your-aws-access-key"
aws_secret_key    = "your-aws-secret-key"
aws_key_pair_name = "kopicloud-key-pair"
aws_key_pair_file = "kopicloud-key-pair.pem"
aws_region        = "eu-west-2"

# Application access
app_sources_cidr   = ["0.0.0.0/0"] # Specify a list of IPv4 IPs/CIDRs which can access app load balancers
admin_sources_cidr = ["0.0.0.0/0"] # Specify a list of IPv4 IPs/CIDRs which can admin instances
