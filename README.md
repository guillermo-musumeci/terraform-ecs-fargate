# Terraform ECS Cluster with Nginx Fargate Containers

Blog post --> https://medium.com/@gmusumeci/how-to-deploy-aws-ecs-fargate-containers-step-by-step-using-terraform-545eeac743be

Deploy ECS cluster with Fargate containers

* **terraform.tfvars** --> update AWS credentials and other settings

* **ecs-cluster-variables.tf** --> update ECS cluster settings

* **nginx-variables.tf** --> update nginx settings

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
