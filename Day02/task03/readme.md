# Exercise 3: Dynamic Parameterization via Conditional Operators

## Goal

Master the ternary conditional operator (`condition ? true_val : false_val`) to adapt resource attributes dynamically based on the environment.

## Task Instructions

### 1. Declare an Input Variable

Create an input variable named `is_production` with:

- Type: `bool`
- Default: `false`

### 2. Create an `aws_instance` Resource

Write a resource block for an AWS EC2 instance.

### 3. Use a Conditional Operator

Inside the resource block, set `instance_type` using a ternary conditional operator so that:

- If `is_production == true`, the instance type is `"t3.medium"`.
- If `is_production == false`, the instance type is `"t2.micro"`.

Example logic:

```hcl
condition ? true_value : false_value
```

### 4. Add Dynamic Tags

Add a `Name` tag using a conditional operator so that:

- `prod-server` when `is_production` is `true`
- `dev-server` when `is_production` is `false`