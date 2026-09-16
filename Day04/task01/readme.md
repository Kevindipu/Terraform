# Exercise 1: Inspecting Local State and Simulating Drift

**Goal:** Understand state tracking, diff resolution, and manual state deletion behavior.

## Requirements

### 1. Setup Project Directory

- Create a fresh directory named `tf-exercise-1`.
- Create a `main.tf` file inside it.

### 2. Write Baseline Infrastructure

- Define the `aws` provider with region `us-east-1`.
- Declare an `aws_instance` resource using:
  - a basic AMI ID
  - instance type `t2.micro`

### 3. Execute and Inspect

Run the following commands:

```bash
terraform init
terraform apply -auto-approve
terraform show
```

Inspect the generated `terraform.tfstate` contents.

### 4. Simulate Configuration Drift

Modify your `aws_instance` by adding a tags block:

```hcl
tags = {
  Name = "Exercise-1-Instance"
}
```

Then run:

```bash
terraform plan
```

Notice that Terraform detects **only the tag addition** instead of recreating the EC2 instance.

### 5. Challenge: Delete the Local State

1. Delete the local state file manually:

   ```bash
   rm terraform.tfstate
   ```

2. Run:

   ```bash
   terraform plan
   ```

3. Observe that Terraform proposes to **create a new EC2 instance** because it has lost the state file and no longer knows the existing instance is already deployed.

4. Clean up before continuing by either:
   - Running `terraform destroy` (if state still exists elsewhere), or
   - Manually deleting the orphaned EC2 instance from the AWS Console or AWS CLI.