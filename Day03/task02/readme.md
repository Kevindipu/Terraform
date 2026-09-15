# Exercise 2: Configurable Web Server with Custom Security Groups

## Objective

Learn how to pass complex variables (lists/maps) and retrieve outputs from child modules into other resources.

## Project Structure

Create a reusable module named `web_server`.

```text
.
├── modules/
│   └── web_server/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf
└── outputs.tf
```

## Task Instructions

### 1. Create the `web_server` Module

Inside `modules/web_server/`, create a module that provisions:

- An AWS Security Group.
- An EC2 instance that uses the created Security Group.

### 2. Declare the Input Variable

In `modules/web_server/variables.tf`, create a variable that accepts a list of ingress ports.

```hcl
variable "allowed_ports" {
  type    = list(number)
  default = [80, 443]
}
```

### 3. Create Dynamic Security Group Rules

In `modules/web_server/main.tf`:

- Create an `aws_security_group`.
- Use a `dynamic "ingress"` block to generate one ingress rule for each port in `var.allowed_ports`.
- Attach the Security Group to the EC2 instance.

### 4. Export Module Outputs

In `modules/web_server/outputs.tf`, output the created:

- `security_group_id`

## Expected Behavior

The module should automatically create ingress rules for every port supplied through `allowed_ports`.

### Example

| `allowed_ports` | Expected Ingress Rules |
|-----------------|-------------------------|
| `[80, 443]` | HTTP and HTTPS |
| `[22, 80, 443]` | SSH, HTTP, and HTTPS |
| `[8080]` | Port 8080 only |