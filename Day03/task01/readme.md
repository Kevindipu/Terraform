# Exercise 1: Build a Reusable Virtual Machine / Instance Module

## Objective

Create a child module that encapsulates virtual instance parameters and consume it twice in your root configuration.

## Project Structure

Create the following directory structure:

```text
.
├── modules/
│   └── virtual_instance/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf
└── outputs.tf
```

## Task Instructions

### 1. Create the Child Module

Inside `modules/virtual_instance/`, create the required Terraform files.

### 2. Define Module Variables

In `modules/virtual_instance/variables.tf`, declare the following input variables:

- `ami_id` – the AMI (or image) ID.
- `instance_type` – the EC2 instance type.
- `environment_tag` – the environment tag (for example, `dev` or `prod`).

### 3. Export Module Outputs

In `modules/virtual_instance/outputs.tf`, create outputs for:

- The instance's `public_ip`.
- The instance's `id`.

### 4. Consume the Module Twice

In the root `main.tf`, call the `virtual_instance` module twice:

| Module | Environment | Suggested Instance Type |
|--------|-------------|--------------------------|
| `dev_instance` | Dev | `t2.micro` or `t3.micro` |
| `prod_instance` | Prod | `t2.small` or `t3.small` |

Pass appropriate values for:

- `ami_id`
- `instance_type`
- `environment_tag`

### 5. Create Root Outputs

In the root `outputs.tf`, expose the public IP addresses of both module instances:

- Dev instance public IP
- Prod instance public IP