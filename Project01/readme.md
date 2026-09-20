# AWS VPC Infrastructure with Terraform

A beginner-friendly Terraform project to build a basic AWS networking environment from scratch.

The goal is to understand **how AWS networking components connect together**, rather than memorizing Terraform syntax.

## Architecture

![AWS VPC Architecture](architecture.png)

The infrastructure creates:

- 1 VPC
- 2 Public Subnets (different Availability Zones)
- 1 Internet Gateway
- 1 Public Route Table
- Route Table Associations
- 2 EC2 Instances (one in each subnet)

---

## Learning Objectives

By completing this project, you should understand:

- What a VPC is and why it is needed
- How CIDR blocks work
- Why subnets are created inside a VPC
- How an Internet Gateway provides internet connectivity
- What Route Tables do
- Why Route Table Associations are required
- How EC2 instances become publicly accessible

---

## Architecture Flow

```text
AWS Cloud
│
└── VPC (172.16.0.0/16)
    │
    ├── Internet Gateway
    │
    ├── Public Route Table
    │       │
    │       ├── 0.0.0.0/0 → Internet Gateway
    │       └── 172.16.0.0/16 → Local
    │
    ├── Public Subnet A (172.16.1.0/24)
    │       └── EC2 Instance
    │
    └── Public Subnet B (172.16.2.0/24)
            └── EC2 Instance