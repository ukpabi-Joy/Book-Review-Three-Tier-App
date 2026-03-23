# Book Review Three-Tier AWS Application

A production-grade three-tier web application deployed on Amazon Web Services 
using Terraform Infrastructure as Code. Built with Next.js frontend, Node.js 
backend API, and MySQL database — each deployed in isolated network tiers for 
security and scalability.

---

## Architecture
```
                        ┌─────────────────┐
                        │    INTERNET     │
                        └────────┬────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Public ALB            │
                    │   (Application LB)      │
                    │   Port 80 / 443         │
                    └────────────┬────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │              WEB TIER                       │
          │    Public Subnets — AZ1 + AZ2               │
          │    10.0.1.0/24 | 10.0.2.0/24               │
          │    EC2 — Next.js via Nginx — Port 80        │
          └──────────────────────┬──────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Internal ALB          │
                    │   Port 3001             │
                    └────────────┬────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │              APP TIER                       │
          │    Private Subnets — AZ1 + AZ2              │
          │    10.0.3.0/24 | 10.0.4.0/24               │
          │    EC2 — Node.js API — Port 3001            │
          │    No Public IP                             │
          └──────────────────────┬──────────────────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │             DATABASE TIER                   │
          │    Private Subnets — AZ1 + AZ2              │
          │    10.0.5.0/24 | 10.0.6.0/24               │
          │    RDS MySQL — Multi-AZ                     │
          │    No Public Access                         │
          └─────────────────────────────────────────────┘
```

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Infrastructure | Terraform | Provision all AWS resources |
| Cloud | Amazon AWS | Host all services |
| Web Server | EC2 (Ubuntu 22.04) | Run Next.js frontend |
| App Server | EC2 (Ubuntu 22.04) | Run Node.js backend |
| Database | RDS MySQL 8.0 | Store application data |
| Frontend | Next.js + Nginx | User interface |
| Backend | Node.js + Express | REST API |
| Process Manager | PM2 | Keep Node.js running |
| Public LB | AWS ALB | Route internet traffic to Web Tier |
| Internal LB | AWS Internal ALB | Route Web Tier to App Tier |

---

## Prerequisites

### Tools Required
| Tool | Install |
|------|---------|
| Terraform >= 1.0 | https://developer.hashicorp.com/terraform/downloads |
| AWS CLI >= 2.0 | https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html |
| Git >= 2.0 | https://git-scm.com/downloads |
| Claude Code | https://claude.ai/code |

### Verify Prerequisites
```bash
terraform -version
aws --version
git --version
claude --version
aws sts get-caller-identity
```

### AWS Requirements
- Active AWS account
- Access Key ID and Secret Access Key
- Sufficient EC2 and RDS quota in us-east-1

---

## Project Structure
```
Book-Review-Three-Tier-App/
├── CLAUDE.md                    ← AI agent instructions
├── README.md                    ← This file
├── .gitignore
├── .claude/
│   ├── subagents/               ← Claude Code subagent definitions
│   │   ├── networking_agent.md
│   │   ├── security_agent.md
│   │   ├── compute_agent.md
│   │   ├── database_agent.md
│   │   └── lb_agent.md
│   └── skills/                  ← Reusable Terraform patterns
│       ├── networking/
│       ├── security/
│       ├── web_tier/
│       ├── app_tier/
│       ├── db_tier/
│       └── load_balancer/
├── terraform/
│   ├── main.tf                  ← Root orchestrator
│   ├── variables.tf             ← Global variables
│   ├── outputs.tf               ← Global outputs
│   └── modules/
│       ├── networking/          ← VPC + 6 subnets + IGW
│       ├── security/            ← 3 Security Groups
│       ├── web_tier/            ← Web EC2 + Nginx
│       ├── app_tier/            ← App EC2 + Node.js
│       ├── db_tier/             ← RDS MySQL Multi-AZ
│       └── load_balancer/       ← Public ALB + Internal ALB
├── scripts/                     ← Helper scripts
└── docs/                        ← Additional documentation
```

---

## Network Design

| Subnet | CIDR | Tier | AZ | Type |
|--------|------|------|----|------|
| web-subnet-1 | 10.0.1.0/24 | Web | us-east-1a | Public |
| web-subnet-2 | 10.0.2.0/24 | Web | us-east-1b | Public |
| app-subnet-1 | 10.0.3.0/24 | App | us-east-1a | Private |
| app-subnet-2 | 10.0.4.0/24 | App | us-east-1b | Private |
| db-subnet-1  | 10.0.5.0/24 | DB  | us-east-1a | Private |
| db-subnet-2  | 10.0.6.0/24 | DB  | us-east-1b | Private |

---

## Security Design

| Tier | Security Group | Port | Source |
|------|---------------|------|--------|
| Web | web-sg-jukpabi | 80, 443, 22 | 0.0.0.0/0 |
| App | app-sg-jukpabi | 3001, 22 | Web SG only |
| DB | db-sg-jukpabi | 3306 | App SG only |

---

## Deployment Guide

### Step 1 — Clone the Repository
```bash
git clone https://github.com/ukpabi-Joy/Book-Review-Three-Tier-App.git
cd Book-Review-Three-Tier-App
```

### Step 2 — Configure AWS Credentials
```bash
aws configure
aws sts get-caller-identity
```

### Step 3 — Generate SSH Key Pair
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/book-review-key -N ""
```

### Step 4 — Create terraform.tfvars
```bash
nano terraform/terraform.tfvars
```
Add:
```
db_password    = "YourSecurePassword!"
admin_password = "YourSecurePassword!"
```

### Step 5 — Initialize Terraform
```bash
cd terraform
terraform init
```

### Step 6 — Validate
```bash
terraform validate
```

### Step 7 — Plan
```bash
terraform plan
```

### Step 8 — Deploy
```bash
terraform apply -auto-approve
```

### Step 9 — Get Outputs
```bash
terraform output
```

### Step 10 — Destroy When Done
```bash
terraform destroy -auto-approve
```

---

## Application Details

### Web Tier — Next.js Frontend
- Runtime: Node.js 18
- Framework: Next.js
- Web Server: Nginx reverse proxy
- Port: 80
- Subnet: Public

### App Tier — Node.js Backend
- Runtime: Node.js 18
- Framework: Express.js
- Process Manager: PM2
- Port: 3001
- Subnet: Private — No Public IP

### Database Tier — MySQL
- Engine: MySQL 8.0
- Service: Amazon RDS
- Multi-AZ: Enabled
- Public Access: Disabled
- Subnet: Private

---

## Cost Estimate

| Resource | Qty | Est. Cost/hr |
|----------|-----|-------------|
| Web EC2 (t3.small) | 2 | ~$0.02 each |
| App EC2 (t3.small) | 2 | ~$0.02 each |
| Public ALB | 1 | ~$0.008 |
| Internal ALB | 1 | ~$0.008 |
| RDS MySQL Multi-AZ | 1 | ~$0.04 |
| **Total** | | **~$0.12/hr** |

> Much cheaper than Azure! Always destroy after testing.

---

## Troubleshooting

### t2.micro Unavailable
```
Error: SkuNotAvailable
```
Fix: Change instance_type to `t3.micro` in variables.tf

### ALB Needs 2 AZs
```
Error: ALB requires subnets in at least 2 AZs
```
Fix: Always pass 2 subnet IDs from different AZs

### RDS Needs Subnet Group
```
Error: DB subnet group not found
```
Fix: Create `aws_db_subnet_group` before `aws_db_instance`

### SSH Key Not Found
```
Error: InvalidKeyPair.NotFound
```
Fix: Run `ssh-keygen -t rsa -b 2048 -f ~/.ssh/book-review-key -N ""`

### terraform init DNS Timeout
```
Error: Could not connect to registry.terraform.io
```
Fix:
```bash
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
terraform init
```

---

## Author
Joy Ukpabi — March 2026
