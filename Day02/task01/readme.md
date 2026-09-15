# Exercise 1: Multi-Region Resource Deployment with Aliases

## Goal

Understand how Terraform uses provider aliases to manage resources across different cloud regions or accounts within a single configuration.

## Task Instructions

### 1. Create a `providers.tf` file

- Define a default `aws` provider pointing to the `us-east-1` region.
- Define a second `aws` provider block pointing to the `eu-central-1` region using an alias named `eu_central`.

### 2. Create a `main.tf` file

Write HCL to create:

- One AWS S3 bucket in `us-east-1` using the default provider.
- One AWS S3 bucket in `eu-central-1` referencing the `aws.eu_central` provider alias.