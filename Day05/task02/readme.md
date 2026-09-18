# Exercise 2: SSH Key Generation & Remote Setup (`remote-exec`)

## Goal

Create an AWS EC2 instance along with its networking components, and run initial system setup scripts using `remote-exec`.

## Tasks to Code

1. Define an `aws_key_pair` resource using Terraform's `tls_private_key` resource (or reference a local `~/.ssh/id_rsa.pub` using `file()`).
2. Write an `aws_instance` block attached to a public subnet and a security group allowing inbound port `22`.
3. Add a `connection` block inside the instance resource specifying:
   - `type = "ssh"`
   - `user = "ubuntu"`
   - `private_key` referencing your private key
   - `host = self.public_ip`
4. Add a `remote-exec` provisioner with an `inline` list of bash commands to:
   - Run `sudo apt-get update -y`
   - Install `python3`, `python3-pip`, and `nginx`
   - Start and enable the `nginx` service