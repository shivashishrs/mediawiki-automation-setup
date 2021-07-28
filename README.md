### **Scalable MediaWiki setup using Terraform, Ansible and Packer**

#### This setup will be deployed on AWS. We are using lots of AWS service. AWS cli setup with **AdministratorAccess** is recommended. 


### Build AMI with packer:
On the root directory of repo run this command to build AMI with packer

`packer build packer.json`

This command with provision the instance with ansible configurations and create AMI as output which will be used in terraform as base image.

### Provision the Infrastructure with terraform
Once the AMI from the packer is ready then run this command to provision the run this command to provision the resources.
Feel free to review the variables.tf file and make any changes if requires. 
Variable.tf file is containing basic default values to make the deployment error free.

`Path: terraform/app/`

### Commands:

`terraform init`

`terraform plan` Review the resources that will be created

`terraform apply` Accept if you want to approve the provision

On the success of `terraform apply` it will return the load balancer url. 
NOTE: If the load balancer url is giving 502 bad gateway then go to codepipeline > mediawiki-demo-codepipeline > Release changes.
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



