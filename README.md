### **Scalable MediaWiki setup using Terraform, Ansible, and Packer**

#### This setup will be deployed on AWS. We are using lots of AWS services.
#### AWS CLI setup with **AdministratorAccess** is recommended.
#### I have tested this resource on us-east-1 region

NOTE: If want to use any pre-configured AWS profile. Then it can be used via
`expose AWS_PROFILE=profile-name`

### Build AMI with packer:
On the root directory of the repo run this command to build AMI with packer

`packer build packer.json`

This command will provision the instance with ansible configurations and create AMI as output, which will be used in terraform as base image.

### Provision the Infrastructure with terraform
Once the AMI from the packer is ready then run this command to provision the resources.
Feel free to review the variables.tf file and make any changes if required.
Variable.tf file is containing basic default values to make the deployment error-free.

`Path: terraform/app/`

### Commands:

`terraform init`

`terraform plan` Review the resources that will be created

`terraform apply` Accept if you want to approve the provision

On the success of `terraform apply` it will return the load balancer URL.
_NOTE_: If the load balancer URL is giving 502 bad gateway then go to code pipeline > MediaWiki-demo-code pipeline > Release changes.
This will deploy the config again on the auto-scaling group instances

The Admin page will be accessible from the ALB URL. The default username and Password are mentions in variables.tf.
This terraform code will create the following resource:

**VPC** - For virtual private cloud with our own networking rule

**Load balancer** - For equally distributing the requests on multiple instances

**Code Pipeline** - For CI/CD process. The code pipeline line will use the s3 bucket for source code. We can replace that with any source repository.
Whenever the scaling event will happen the code pipeline will automatically get triggered and install the latest code and config from s3

**RDS** - Database in the private subnet with Access from autoscaling group's instances only.

**EC2** - Instances in the private subnet to serve the application

**Nat Gateway** - Nat Gateway to allow ec2 instance to download packages from the internet

**Auto Scaling Group** ASG with maintain the desired number of instances. On the scaling event, it will scale out the instance and code deploy with configuring the instance automatically with the help of code deploy.

**Parameter Store** Securely stores the database and other credentials.

**S3** To store the source code and provide to codepipeline

This Terraform script will also provision the jumpbox server to be able to connect and troubleshoot the instance

**NOTE** Terraform will use the local state. If you want to use the remote state s3 or any other just add the remote state config in main.tf file. 

## Troubleshooting guide

Access Denied Error: Check the IAM permission and configuration on the local machine

Jumpbox Provision failed: SSH into the jumpbox instance and try to connect with the Database. If not able to connect try to add jumpbox security group into the database security group

LocalSettings.php not found: Rerun the code pipeline and it will add the LocalSettings file.
