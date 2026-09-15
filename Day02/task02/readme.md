# Exercise 2: Input & Output Variable Separation with `.tfvars`

## Goal

Practice project modularization by separating code into `variables.tf`, `main.tf`, `outputs.tf`, and environment-specific `terraform.tfvars` files.

## Task Instructions

### 1. Create a `variables.tf` file

Declare the following input variables:

- `instance_type`
  - Type: `string`
  - Default: `"t2.micro"`
- `ami_id`
  - Type: `string`
- `environment`
  - Type: `string`

### 2. Create a `terraform.tfvars` file

Set the following values:

```hcl
ami_id      = "ami-0c555217b81143732"
environment = "dev"
```

> Replace the AMI ID with any valid AMI for your chosen AWS region if needed.

### 3. Create a `main.tf` file

Define an `aws_instance` resource that:

- Uses `var.ami_id` for the AMI.
- Uses `var.instance_type` for the instance type.
- Adds a tag:

  - `Environment = var.environment`

### 4. Create an `outputs.tf` file

Create output blocks that expose:

- The EC2 instance's `public_ip`.
- The EC2 instance's `arn`.