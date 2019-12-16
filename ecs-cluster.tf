# define & build the ecs cluster | ecs-cluster.tf

# create ecs cluster
resource "aws_ecs_cluster" "aws-ecs" {
  name = var.app_name
}

# get latest ecs ami
data "aws_ami" "ecs-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

# override ecs ami image
variable "aws_ecs_ami_override" {
  default     = ""
  description = "Machine image to use for ec2 instances"
}

locals {
  aws_ecs_ami = var.aws_ecs_ami_override == "" ? data.aws_ami.ecs-ami.id : var.aws_ecs_ami_override
}

locals {
  ebs_types = ["t2", "t3", "m5", "c5"]

  cpu_by_instance = {
    "t2.small"     = 1024
    "t2.large"     = 2048
    "t2.medium"    = 2048
    "t2.xlarge"    = 4096
    "t3.medium"    = 2048
    "m5.large"     = 2048
    "m5.xlarge"    = 4096
    "m5.2xlarge"   = 8192
    "m5.4xlarge"   = 16384
    "m5.12xlarge"  = 49152
    "m5.24xlarge"  = 98304
    "c5.large"     = 2048
    "c5d.large"    = 2048
    "c5.xlarge"    = 4096
    "c5d.xlarge"   = 4096
    "c5.2xlarge"   = 8192
    "c5d.2xlarge"  = 8192
    "c5.4xlarge"   = 16384
    "c5d.4xlarge"  = 16384
    "c5.9xlarge"   = 36864
    "c5d.9xlarge"  = 36864
    "c5.18xlarge"  = 73728
    "c5d.18xlarge" = 73728
  }

  mem_by_instance = {
    "t2.small"     = 1800
    "t2.medium"    = 3943
    "t2.large"     = 7975
    "t2.xlarge"    = 16039
    "t3.medium"    = 3884
    "m5.large"     = 7680
    "m5.xlarge"    = 15576
    "m5.2xlarge"   = 31368
    "m5.4xlarge"   = 62950
    "m5.12xlarge"  = 189283
    "m5.24xlarge"  = 378652
    "c5.large"     = 3704
    "c5d.large"    = 3704
    "c5.xlarge"    = 7624
    "c5d.xlarge"   = 7624
    "c5.2xlarge"   = 15463
    "c5d.2xlarge"  = 15463
    "c5.4xlarge"   = 31142
    "c5d.4xlarge"  = 31142
    "c5.9xlarge"   = 70341
    "c5d.9xlarge"  = 70341
    "c5.18xlarge"  = 140768
    "c5d.18xlarge" = 140768
  }
}

# ecs cluster runner role policies
resource "aws_iam_role" "ecs-cluster-runner-role" {
  name               = "${var.app_name}-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs-cluster-runner-policy" {
  statement {
    actions   = ["ec2:Describe*", "ecr:Describe*", "ecr:BatchGet*"]
    resources = ["*"]
  }
  statement {
    actions   = ["ecs:*"]
    resources = ["arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.app_name}/*"]
  }
}

resource "aws_iam_role_policy" "ecs-cluster-runner-role-policy" {
  name   = "${var.app_name}-cluster-runner-policy"
  role   = aws_iam_role.ecs-cluster-runner-role.name
  policy = data.aws_iam_policy_document.ecs-cluster-runner-policy.json
}

resource "aws_iam_instance_profile" "ecs-cluster-runner-profile" {
  name = "${var.app_name}-cluster-runner-iam-profile"
  role = aws_iam_role.ecs-cluster-runner-role.name
}

# ec2 user data for hard drive
data "template_file" "user_data_cluster" {
  template = file("templates/cluster_user_data.sh")
  vars = {
    ecs_cluster = aws_ecs_cluster.aws-ecs.name
  }
}

# create ec2 instance for the ecs cluster runner
resource "aws_instance" "ecs-cluster-runner" {
  ami                         = local.aws_ecs_ami
  instance_type               = var.cluster_runner_type
  subnet_id                   = element(aws_subnet.aws-subnet.*.id, 0)
  vpc_security_group_ids      = [aws_security_group.ecs-cluster-host.id]
  associate_public_ip_address = true
  key_name                    = var.aws_key_pair_name
  user_data                   = data.template_file.user_data_cluster.rendered
  count                       = var.cluster_runner_count
  iam_instance_profile        = aws_iam_instance_profile.ecs-cluster-runner-profile.name

  tags = {
    Name      = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role        = "ecs-cluster"
  }

  volume_tags = {
    Name      = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role        = "ecs-cluster"
  }
}

# create security group and segurity rules for the ecs cluster
resource "aws_security_group" "ecs-cluster-host" {
  name        = "${var.app_name}-ecs-cluster-host"
  description = "${var.app_name}-ecs-cluster-host"
  vpc_id      = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_name}-ecs-cluster-host"
    Environment = var.app_environment
    Role        = "ecs-cluster"
  }
}

resource "aws_security_group_rule" "ecs-cluster-host-ssh" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description       = "admin SSH access to ecs cluster"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.admin_sources_cidr
}

resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description       = "ecs cluster egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# output ecs cluster public ip
output "ecs_cluster_runner_ip" {
  description = "External IP of ECS Cluster"
  value       = [aws_instance.ecs-cluster-runner.*.public_ip]
}