### **Scalable MediaWiki setup using Terraform, Ansible and Packer**

#### This setup will be deployed on AWS. We are using lots of AWS service.
#### AWS CLI setup with **AdministratorAccess** is recommended.
#### I have tested this resource on us-east-1 region

NOTE: If want to use any pre-configured aws profil. Then it can be use via
`expose AWS_PROFILE=profile-name`

### Build AMI with packer:
On the root directory of repo run this command to build AMI with packer

`packer build packer.json`

This command with provision the instance with ansible configurations and create AMI as output which will be used in terraform as base image.

### Provision the Infrastructure with terraform
Once the AMI from the packer is ready then run this command to provision the resources.
Feel free to review the variables.tf file and make any changes if requires.
Variable.tf file is containing basic default values to make the deployment error free.

`Path: terraform/app/`

### Commands:

`terraform init`

`terraform plan` Review the resources that will be created

`terraform apply` Accept if you want to approve the provision

On the success of `terraform apply` it will return the load balancer url.
_NOTE_: If the load balancer url is giving 502 bad gateway then go to codepipeline > mediawiki-demo-codepipeline > Release changes.
This will deploy the config again on the auto scaling group instances

The Admin page will be accessible from the ALB URL. Default username and Password is mention in variables.tf.
This terraform code will create following resource:

**VPC** - For virtual private cloud with our own networking rule

**Load balancer** - For equally distributing the requests on multiple instances

**Code Pipeline** - For CI/CD process. The codepipeline line will use the s3 bucket for source code. We can replace that with any source repository.
Whenever the scaling event will happen the codepipeline will automatically get triggered and install the latest code and config from s3

**RDS** - Database in the private subnet with Access from autoscaling group's instances only.

**EC2** - Instances in private subnet to serve the application

**Nat Gateway** - Nat Gateway to allow ec2 instance to download packages from the internet

**Auto Scaling Group** ASG with maintain the desire number of instances. On the scaling event it will scale out the instance and code deploy with configure the instance automatically with the help of codedeploy.

**Parameter Store** Securely stores the database and other credentials.

This Terraform script will also provision the jumpbox server to be able to connect and troubleshoot the instance

**NOTE** Terraform will use the local state. If you want to use the remote state s3 or any other just add the remote state config in main.tf file. 

## Troubleshooting guide

Access Denied Error: Check the IAM permission and configuration on local machine

Jumpbox Provision failed: SSH into the jumpbox instance and try to connect with Database. If not able to connect try to add jumpbox security group into database security group

LocalSettings.php not found: Rerun the codepipeline and it will add the LocalSettings file.
