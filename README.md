# Terraform ECS Cluster with Nginx Fargate Containers

Deploy ECS cluster with Fargate containers

Blog post --> https://medium.com/@gmusumeci/how-to-deploy-aws-ecs-fargate-containers-step-by-step-using-terraform-545eeac743be

* **ecs-cluster-policies.tf** --> ECS Cluster policies

* **ecs-cluster-variables.tf** --> ECS Cluster variables

* **ecs-cluster.tf** --> build the ECS Cluster 

* **network.tf** --> create network components (VPC, Subnet, Internet Gateway, Routes)

* **nginx-alb.tf** --> Nginx application load balancer

* **nginx-container.tf** --> Nginx containers

* **nginx-segurity.tf** --> Nginx security groups

* **nginx-variables.tf** --> update Nginx settings

* **nginx.json** --> Nginx application container information

* **provider.tf** --> AWS Provider

* **terraform.tfvars** --> update AWS credentials and other settings

* **variables-app.tf** --> application variables

* **variables-auth.tf** --> AWS authentication variables

## How to deploy the cluster in AWS

1) Create an IAM user and update the file **terraform.tfvars** with the credentials. To create an IAM user follow the step 1 of the  link below.

https://medium.com/@gmusumeci/how-to-create-an-iam-account-and-configure-terraform-to-use-aws-static-credentials-a8ea4dd4fdfc

2) Update the Amazon ECS ARN and resource ID settings

Open your AWS Console and go to the ECS service. On the left side, under the Amazon ECS, Account Settings, check the Container instance, Service and Task override checkbox.

3) Generate and download an EC2 Key pair (.pem file). Instructions are below

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

3) Run Terraform

a) Clone the git repository

b) Update settings and copy folders (if needs), read above

c) Run the command **terraform init** from the command line, in the same folder where your code is located.

d) Then run the command **terraform apply** from the command line to start building the infrastructure.
