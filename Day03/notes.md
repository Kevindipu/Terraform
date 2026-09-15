# Terraform Modules — Study & Interview Notes

## 1. Core Concepts & Overview

A **Terraform Module** is a set of Terraform configuration files in a single directory used to manage a collection of related resources.

### Architectural Analogy
In standard programming languages (like Python, Java, or C++):
* **Function Call** $\rightarrow$ `module` block in Root Configuration
* **Function Parameters** $\rightarrow$ `variables.tf` (Input Variables)
* **Function Logic/Body** $\rightarrow$ `main.tf` (Resource Block Declarations)
* **Return Values** $\rightarrow$ `outputs.tf` (Output Definitions)

---

### Key Benefits of Using Modules

1. **DRY (Don't Repeat Yourself) Principle:** Avoid duplicating resource code across environments (`dev`, `staging`, `prod`).
2. **Encapsulation & Abstraction:** Hide complex resource setup details behind simple input parameters for consumer teams.
3. **Standardization & Governance:** Enforce corporate policies, naming conventions, and security tagging guidelines centrally.
4. **Maintainability:** Fix bugs or upgrade infrastructure standards in one module source instead of editing hundreds of individual resource files.

---

## 2. Module Types & Categorization

| Module Type | Description | Source Syntax Example |
| :--- | :--- | :--- |
| **Root Module** | The top-level working directory containing `.tf` files where `terraform init` and `apply` are executed. | `.` (Current Working Directory) |
| **Local Child Module** | Sub-directories within the same repository containing isolated resource code. | `source = "./modules/ec2_instance"` |
| **Remote Registry Module** | Standardized, public, or private modules hosted on Terraform Registry or VCS (GitHub/GitLab). | `source = "terraform-aws-modules/vpc/aws"` <br> `source = "git::https://github.com/org/repo.git?ref=v1.2.0"` |

---

## 3. Recommended Directory Structure

```text
terraform-infrastructure/
├── modules/                         # Subdirectory for reusable Child Modules
│   └── ec2_instance/                # Specific module folder
│       ├── main.tf                  # Defines module resources
│       ├── variables.tf             # Input variables consumed by the module
│       └── outputs.tf               # Values exported by the module
│
├── environments/                    # Root Module directory
│   ├── dev/
│   │   ├── main.tf                  # Invokes local/remote modules
│   │   ├── variables.tf             # Root-level variables
│   │   ├── terraform.tfvars         # Values for environment
│   │   └── outputs.tf               # Exports final state data
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
```

---

## 4. Practical Implementation Guide

### Step 1: Define the Child Module (`modules/ec2_instance/`)

#### `modules/ec2_instance/variables.tf`
```hcl
variable "ami_id" {
  description = "The Amazon Machine Image ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Target deployment environment (dev, stage, prod)"
  type        = string
}

variable "instance_tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
```

#### `modules/ec2_instance/main.tf`
```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = merge(
    {
      Name        = "${var.environment}-instance"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.instance_tags
  )
}
```

#### `modules/ec2_instance/outputs.tf`
```hcl
output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the created EC2 instance"
  value       = aws_instance.this.public_ip
}
```

---

### Step 2: Call the Module in Root (`environments/dev/main.tf`)

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Invoking the custom local child module for Dev
module "web_server_dev" {
  source        = "../../modules/ec2_instance"
  ami_id        = "ami-0c555d735156605d6"
  instance_type = "t2.micro"
  environment   = "dev"

  instance_tags = {
    Owner = "DevOps-Team"
  }
}

# Invoking the same module for Production
module "web_server_prod" {
  source        = "../../modules/ec2_instance"
  ami_id        = "ami-0c555d735156605d6"
  instance_type = "t3.medium"
  environment   = "prod"
}
```

#### Exporting Child Module Outputs from Root (`environments/dev/outputs.tf`)
```hcl
output "dev_server_public_ip" {
  description = "Public IP for Development Server"
  value       = module.web_server_dev.public_ip
}

output "prod_server_public_ip" {
  description = "Public IP for Production Server"
  value       = module.web_server_prod.public_ip
}
```

---

## 5. CLI Execution & Lifecycle Rules

1. **`terraform init`**
   * Must be run whenever a module block is added, modified in `source`, or removed.
   * Downloads remote modules to `.terraform/modules` or creates local symlinks.
2. **`terraform plan`**
   * Evaluates input variables, reads module definitions, and previews the exact dependency graph.
3. **`terraform apply`**
   * Executes resource creation across all declared modules in the proper dependency order.

---

## 6. Top Interview Questions & High-Yield Answers

### Q1: What happens if you add a new `module` block in your root file and immediately run `terraform plan`?
**Answer:** Terraform will throw an error stating that the module is not installed. Whenever module references or sources change, you must execute `terraform init` to download or symlink the module files into `.terraform/modules/`.

---

### Q2: How do you pass output data from Module A to Module B?
**Answer:** By referencing Module A's output variable in Module B's input parameter inside the root `main.tf`.

```hcl
module "vpc" {
  source = "./modules/vpc"
}

module "app_server" {
  source    = "./modules/ec2_instance"
  subnet_id = module.vpc.subnet_id  # Implicit dependency created
}
```

---

### Q3: What is the difference between referencing a local module path vs. a Git repository with tags?
**Answer:**
* **Local path (`./modules/vpc`):** Changes in module files take effect immediately upon execution. Good for local testing, but risky for environment isolation.
* **Git Repository Tag (`git::https://github.com/org/tf-modules.git?ref=v1.2.0`):** Provides explicit version control and stability across teams. Production environments should always use pinned release versions (`?ref=vX.Y.Z`).

---

### Q4: Can child modules access variables defined in the root module directly?
**Answer:** No. Variables defined in the root module are scoped strictly to the root. They must be explicitly passed into the module block as arguments. Child modules only receive input variables explicitly declared in their own `variables.tf`.

---

### Q5: What are industry best practices when building enterprise Terraform modules?

1. **Single-Responsibility Principle:** Keep modules granular (e.g., separate modules for VPC, Security Groups, and EKS rather than one giant architecture module).
2. **Strict Versioning:** Pin remote module sources using semantic tags (`?ref=v1.0.0`).
3. **Sensible Defaults:** Set defaults in `variables.tf` for optional features, but leave required operational parameters (like `environment` or `vpc_id`) without defaults to enforce input validation.
4. **Clear Outputs:** Export essential identifiers, ARNs, and connection strings (`id`, `arn`, `ip`) to enable dynamic resource linking.
5. **Enforce Tagging Strategies:** Use `merge()` inside modules to apply mandatory corporate tags alongside custom user tags.