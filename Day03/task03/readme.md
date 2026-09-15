# Exercise 3: Remote Source Modules & Module Versioning

## Objective

Learn how to source modules from GitHub repositories or the official Terraform Registry instead of local directories.

## Task Instructions

### 1. Use a Terraform Registry Module

Source a published Terraform Registry module, such as:

- `terraform-aws-modules/vpc/aws` (AWS)
- An equivalent Azure Virtual Network (VNet) module

Instead of using a local `source = "./modules/..."`.

### 2. Pin the Module Version

Constrain the module version explicitly.

```hcl
version = "~> 5.0"
```

This ensures Terraform installs a compatible version within the `5.x` release series.

### 3. Configure the VPC Module

Pass the required arguments to create:

- **1 Public Subnet**
- **1 Private Subnet**

Your configuration should include values for items such as:

- VPC name
- VPC CIDR block
- Availability Zone
- Public subnet CIDR
- Private subnet CIDR

### 4. Use the Module's Outputs

Reference an output from the module, such as:

```hcl
module.vpc.vpc_id
```

Use that output in another resource in your root configuration, for example:

- An `aws_security_group` inside the VPC
- An EC2 instance launched into one of the VPC's subnets

## Expected Outcome

Your root configuration should:

1. Download a remote Terraform Registry module.
2. Create a VPC with one public and one private subnet.
3. Reuse the module's outputs to deploy another resource into the newly created VPC.