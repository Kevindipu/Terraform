# Terraform Notes

---

## 1. What is Infrastructure as Code (IaC)?

**Definition:** IaC is the practice of managing and provisioning infrastructure through machine-readable definition files (code/scripts) rather than through manual processes or user interfaces.

**Problem with Manual Provisioning:**
UI-based resource creation (e.g., via AWS Console) is error-prone, time-consuming, and hard to replicate across multi-team or multi-environment setups.


**Alternative Approaches:**
* **Scripts & SDKs:** AWS CLI, Python (`boto3`), or Shell scripts interacting with AWS APIs. Requires heavy programming knowledge and custom logic.
* **Provider-Specific Templating:** AWS CloudFormation Templates (CFT), Azure Resource Manager (ARM), OpenStack Heat Templates. These let users declare infra using YAML or JSON.



---

## 2. Why Choose Terraform Over Other IaC Tools?

**Vendor Agnostic / Universal Tool:**
* Tools like CloudFormation (AWS) or ARM (Azure) only work within their respective cloud environments.
* Terraform supports multiple cloud providers (AWS, Azure, GCP, OpenStack, Kubernetes) using a single standard syntax (HashiCorp Configuration Language - HCL).


**API-as-Code Concept:**
Terraform converts HCL code into provider-specific API calls under the hood.


**State Management:**
Keeps track of real-world resource state using state files (`terraform.tfstate`).


**Ecosystem & Maturity:**
Large community, robust module ecosystem, and widespread enterprise adoption make it a core DevOps requirement.



---

## 3. Terraform Architecture & Workflow (Lifecycle Commands)

The core lifecycle of a Terraform deployment consists of four primary stages:

1. **`terraform init`**
* Initializes the working directory containing Terraform configuration files.
* Downloads necessary provider plugins (e.g., AWS provider) declared in `.tf` files.


2. **`terraform plan`**
* Performs a **dry run** to determine what actions are needed to reach the desired state specified in the configuration.
* Displays planned additions, modifications, or deletions without altering infrastructure.


3. **`terraform apply`**
* Executes the actions proposed in the plan to create, update, or destroy infrastructure.
* Prompts for confirmation before applying changes.


4. **`terraform destroy`**
* Reads the state file and safely removes all resources managed by the current Terraform configuration.



---

## 4. Setting Up Authentication for AWS

To execute Terraform against AWS:

1. **Configure Credentials:** Use the AWS CLI to store access credentials locally via:
```bash
aws configure

```


Provide the `AWS Access Key ID`, `AWS Secret Access Key`, default region (e.g., `us-east-1`), and output format (`json`).
2. **Provider Declaration:** Define the provider block in your Terraform configuration (`main.tf`):
```hcl
provider "aws" {
  region = "us-east-1"
}

```


*Terraform automatically detects credentials configured via `aws configure` or environment variables.*

---

## 5. Sample Configuration (`main.tf`)

Below is a basic example used to launch an EC2 instance on AWS:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c7217cdde317cfec" # Replace with a valid AMI ID in your region
  instance_type = "t2.micro"
  subnet_id     = "subnet-xxxxxxxxx"      # Specify valid Subnet ID
  key_name      = "AWS-key-pair"          # Pre-created Key Pair name

  tags = {
    Name = "Terraform-Demo-Instance"
  }
}

```

---

## 6. Key Troubleshooting Points & Common Mistakes

**Missing / Invalid AMI ID:** AMIs are region-specific. Providing an invalid AMI ID or an AMI ID from another region causes execution failures during `terraform apply`.
**Missing Subnet / VPC Issues:** Launching instances without a default VPC/subnet requires explicitly defining `subnet_id` in the `aws_instance` resource.
**Prerequisite Knowledge:** Effective use of Terraform requires understanding the underlying cloud provider resources (e.g., Subnets, Security Groups, IAM Roles).

---

## 7. What is a Terraform State File (`terraform.tfstate`)?

**Purpose:** A JSON file created locally after executing `terraform apply`.

**Role:**
* Serves as the single source of truth mapping declared HCL code to real-world cloud resources.
* Allows Terraform to track changes, determine diffs during `terraform plan`, and manage existing infra without re-creating resources.


**Note:** Advanced setups utilize Remote Backend State (e.g., AWS S3 with DynamoDB locking) to secure sensitive information and support multi-developer workflows.

---

## 8. Quick Interview Cheat-Sheet Questions

1. **What is IaC and why is Terraform preferred over CloudFormation?**
* *Answer:* IaC automates infrastructure provisioning via code. Terraform is preferred because it is multi-cloud/vendor-agnostic, relies on a unified syntax (HCL), and uses state files to track state across different providers.


2. **Describe the four fundamental Terraform commands.**
* *Answer:* `init` (downloads providers/plugins), `plan` (previews execution/dry run), `apply` (creates/updates resources), `destroy` (teardowns resources listed in state).


3. **What is the purpose of `terraform.tfstate`?**
* *Answer:* It stores the mapping between configuration code and deployed cloud resources, allowing Terraform to track changes and maintain infrastructure state.
