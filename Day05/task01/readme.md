# Terraform Exercise: Provisioners and Local File Generation

## Goal

Write a Terraform configuration that creates an S3 bucket or local dummy resource and uses `local-exec` to record build metadata to a local log file, while using `local_file` or template generation to prepare a dynamic web server configuration file.

## Tasks to Code

1. Define a `local-exec` provisioner inside a resource block to write the deployment timestamp and target AWS region into a local file named `deploy_audit.log`.
2. Generate a custom configuration file locally using `local_file` or provisioners containing environment variables (e.g., `APP_ENV=production`, `PORT=8080`).
3. Set up `on_failure = continue` inside one of the provisioners and test how Terraform behaves when a shell command fails.