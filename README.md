# How To Create Your AWS VPCs Pillars With Terraform

![GitHub license](https://img.shields.io/badge/license-MIT-informational)
![GitHub version](https://img.shields.io/badge/terraform-v0.13.5-success)
![GitHub version](https://img.shields.io/badge/terraform%20vpc%20module-~%3E%202.64-success)
![GitHub version](https://img.shields.io/badge/terraform%20ec2--instance%20module-~%3E%202.15-success)
![GitHub version](https://img.shields.io/badge/local__machine__OS-OSX-blue)

![VPCs_Scheme](https://s3.eu-central-1.amazonaws.com/apprenticecto.com/vpc_peering3.png)


This [repo](https://github.com/apprenticecto/create_dev_vpc) set-up a development [VPC](https://aws.amazon.com/vpc/) and launched basic [EC2](https://aws.amazon.com/ec2/) instances. All via [Terraform](https://www.terraform.io/).

Now let's move on by adding a **management VPC**, which is used for "cross-services", such as monitoring, logging, [CI/CD](https://en.wikipedia.org/wiki/CI/CD).

VPCs are deployed in one [region and availability zone](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html); both VPCs have internet access through [internet gateways](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) and [NAT gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html).

[VPC peering](https://docs.aws.amazon.com/vpc/latest/peering/what-is-vpc-peering.html) ensures connectivity between the two VPCs.

A basic [Bastion Host](https://aws.amazon.com/quickstart/architecture/linux-bastion/) is deployed to get access to the EC2 instance in the private subnet of the peered VPC.

## Terraform Code

Terraform code is segregated into directories:

- `dev_vpc`containing the code to set-up the development VPC, EC2 bastion host, and the security group enabling SSH traffic
- `mgmt_vpc`containing the code to set-up the management VPC, EC2 private instance, and the security group enabling SSH traffic
- `mgmt_dev_vpcs_peering`containing the code to set-up the VPC peering, the updates of route tables to allow traffic routing between the VPCs.

## IPv4 Addressing Scheme Definition

### Development VPC
- CIDR: 10.0.0.0/16
- private subnet: 10.0.1.0/24
- public subnet: 10.0.101.0/24

### Management VPC
- CIDR: 10.20.0.0/16
- private subnet: 10.20.1.0/24
- public subnet: 10.20.101.0/24

## Bastion Host SSH key pair definition

To access the bastion host from your local machine, you need to create the SSH Keypair to access the bastion host via SSH. To do so, launch the command from your terminal:
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f $HOME/.ssh/your_key_name
```

By default, your newly generated key files (private and public) will be stored in `~/.ssh` folder. 

Then open your `your_key_name.pub` and copy its content; paste it in the variable `ssh_public_key` in `mgmt_vpc/variables.tf` file. 

Filename `your_key_name` is referenced in mgmt_vpc Terraform code and the .pub file contents have to be added in `variables.tf` file.  

To let your bastion host access via ssh the private instance on the peered vpc, you need to set-up the [ssh agent forwarding](https://www.cloudsavvyit.com/25/what-is-ssh-agent-forwarding-and-how-do-you-use-it/) on your local machine.

## Dev Private Instance SSH key pair definition

Follow the same procedure to create and utilize ssh keypair for your private ec2 istance in dev_vpc.

## Build your infrastructure

### Management VPC 

Cd into your `mgmt_vpc` folder and:

- launch `terraform init`
- launch `terraform plan` to check that everything is all right before actually creating infrastructure
- launch `terraform apply` and enter 'yes' when prompted (or use `terraform apply -auto-approve`)

At the end output variables defined in `outputs.tf` file are displayed.

### Development VPC 

Cd into your `dev_vpc folder and:

- launch `terraform init`
- launch `terraform plan` to check that everything is all right before actually creating infrastructure
- launch `terraform apply` and enter 'yes' when prompted (or use `terraform apply -auto-approve`)

At the end, the values of output variables defined in `outputs.tf` file are displayed.

### VPC Peering 

Cd into your `mgmt_dev_vpcs_peering` folder and:

- launch `terraform init`
- launch `terraform plan` to check that everything is all right before actually creating infrastructure
- launch `terraform apply` and enter 'yes' when prompted (or use `terraform apply -auto-approve`)

In the end, the values of output variables defined in `outputs.tf` file are displayed.

## Inspect Your Infrastructure

Terraform writes configuration data into a file called `terraform.tfstate`, which you have in your local repo. This file contains the IDs and properties of the resources Terraform created so that Terraform can manage or destroy those resources going forward.

To inspect your infrastructure configuration launch `terraform show` from any of your environment directories.

## SSH into your bastion host

From your terminal, launch the command:
```
ssh -A ubuntu@<dns public name of your bastion host>
```

You should get a message like: "The authenticity of host 'dns public name'  ('public ip address')' can't be established.
ECDSA key fingerprint is <SHA256 fingerpint>.
Are you sure you want to continue connecting (yes/no/[fingerprint])?": type 'yes'.

Now you should successfully be logged into your bastion host!

To login to your private instance on the peered VPC, launch the command form your bastion host:
```
ssh ubuntu@<dns private name of your private ec2 instance>
```

This proves that peering is working and that the ssh traffic is properly routed and enabled!


## Destroy Your infrastructure

To destroy your infrastructure, use `terraform destroy -auto-approve`, in each folder, reversing the creation order.

## Considerations On The Architecture

This is a simplified set-up, but covers the necessary steps to segregate environments and build a cross-vpc which offers management services and proves the power of the atuomation approach to infrastructure building, by using modular code. Easily, a production VPC can be added and peered to the management VPC.

State is managed locally, in default `terrform.tfstate` files, located in each folder. 

This approach is simple, good for learning, brings modularity and segregation, but makes a bit more complex handling infrastructure code changes in each environment.

A production-grade set-up needs more, thought. For instance:

- management of remote state for infrastructure code
- central and secure management of secrets
- bastion host hardening, or VPN access
- segregation of mgmt_vpcs into dev and prod; the latter serving application environments (typically dev, staging, prod)
- segregation of AWS Accounts for each environment and centralization of account managment
- introduction of persistence layer in apps environments (e.g. for DBs)

## Authors

This repository is maintained by [ApprenticeCTO](https://github.com/apprenticecto) with great help from [Terraform AWS Documentation](https://learn.hashicorp.com/collections/terraform/aws-get-started).

## License

MIT Licensed. See LICENSE for full details.


