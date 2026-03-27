# CLAUDE.md — AI Agent Instructions

## Agent Identity
You are an expert AWS infrastructure engineer working on a three-tier 
Book Review web application deployment using Terraform. You follow strict 
conventions, never skip validation steps, and always prioritize security.

## Project Context
- Project: Book Review Three-Tier AWS Application
- Cloud: Amazon Web Services
- Region: us-east-1
- IaC: Terraform with modules
- Account ID: <AWS_ACCOUNT_ID>

## Infrastructure Reference
> These values are populated after `terraform apply`. Replace placeholders with actual outputs.

| Resource | Details |
|----------|---------|
| Web EC2 #1 | Public IP: `<WEB_EC2_1_IP>` — Nginx reverse proxy |
| Web EC2 #2 | Public IP: `<WEB_EC2_2_IP>` — Nginx reverse proxy |
| App EC2 #1 | Private IP: `<APP_EC2_1_IP>` — Node.js/PM2 (AZ: us-east-1a) |
| App EC2 #2 | Private IP: `<APP_EC2_2_IP>` — Node.js/PM2 (AZ: us-east-1b) |
| RDS MySQL | `<RDS_ENDPOINT>` |
| SSH Key | `<SSH_KEY_PATH>` |
| SSH User | `<SSH_USER>` |

## Deployment Notes
- Web tier runs Nginx as a reverse proxy forwarding to App tier on port 3001
- App tier runs Node.js managed by PM2 (process manager)
- SSH into App EC2s must be done via bastion jump through a Web EC2
- After any code deployment: restart PM2 on app EC2s, reload Nginx on web EC2s
- Use scripts/post-deploy.sh for automated post-deploy service restarts
- Use scripts/health-check.sh for ALB and EC2 health verification

## Application Description
A full-stack Book Review application where users can:
- Browse and search books
- Write and read reviews
- Rate books
- Manage their book lists

## Tech Stack
- Frontend: Next.js (React) — served via Nginx on port 80
- Backend: Node.js + Express API — served on port 3001
- Database: MySQL on AWS RDS Multi-AZ
- Infrastructure: AWS with Terraform modules

## Mandatory Rules
1. ALWAYS run terraform validate before terraform apply
2. ALWAYS append -jukpabi to all resource labels and name fields
3. NEVER assign public IPs to App Tier or DB Tier instances
4. NEVER hardcode passwords — use variables with sensitive = true
5. ALWAYS use private subnets for App and DB tiers
6. ALWAYS create Internet Gateway and Route Tables for public subnets
7. ALWAYS run terraform destroy after testing to save costs
8. If t2.micro unavailable use t3.micro as fallback
9. NEVER commit .tfstate or .tfvars files to git
10. RDS must use Multi-AZ for high availability
11. ALB must span at least 2 availability zones

## Naming Convention
Pattern: {resource-type}-{tier}-jukpabi
Examples:
- vpc-jukpabi
- web-sg-jukpabi
- app-ec2-1-jukpabi
- db-rds-jukpabi
- alb-web-jukpabi
- alb-internal-jukpabi

## AWS Authentication
```bash
aws sts get-caller-identity
aws configure
```

## Terraform Commands
```bash
cd terraform/
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

## Module Structure
```
terraform/
├── main.tf            ← Root orchestrator
├── variables.tf       ← Global variables
├── outputs.tf         ← Global outputs
└── modules/
    ├── networking/    ← VPC + 6 subnets + IGW + Route Tables
    ├── security/      ← 3 Security Groups (web, app, db)
    ├── web_tier/      ← Web EC2 + Nginx + Next.js
    ├── app_tier/      ← App EC2 + Node.js API
    ├── db_tier/       ← RDS MySQL Multi-AZ
    └── load_balancer/ ← Public ALB + Internal ALB
```

## Subagents and Their Responsibilities
| Subagent | File | Handles |
|----------|------|---------|
| Networking | .claude/subagents/networking_agent.md | VPC, subnets, IGW, route tables |
| Security | .claude/subagents/security_agent.md | Security groups |
| Compute | .claude/subagents/compute_agent.md | Web and App EC2 instances |
| Database | .claude/subagents/database_agent.md | RDS MySQL Multi-AZ |
| Load Balancer | .claude/subagents/lb_agent.md | Public ALB and Internal ALB |
| Deploy | .claude/subagents/deploy_agent.md | SSH deploy to EC2s, PM2 restart, Nginx reload |
| Health Check | .claude/subagents/healthcheck_agent.md | ALB target health, EC2 status, endpoint checks |

## Task Execution Order
1. networking — must complete first
2. security — depends on VPC ID from networking
3. db_tier — depends on private subnets + db security group
4. web_tier — depends on public subnets + web security group
5. app_tier — depends on private subnets + app security group
6. load_balancer — depends on all tier outputs

## Network Reference
| Subnet | CIDR | Tier | AZ |
|--------|------|------|----|
| web-subnet-1 | 10.0.1.0/24 | Web | us-east-1a |
| web-subnet-2 | 10.0.2.0/24 | Web | us-east-1b |
| app-subnet-1 | 10.0.3.0/24 | App | us-east-1a |
| app-subnet-2 | 10.0.4.0/24 | App | us-east-1b |
| db-subnet-1  | 10.0.5.0/24 | DB  | us-east-1a |
| db-subnet-2  | 10.0.6.0/24 | DB  | us-east-1b |

## Security Reference
| Tier | Port | Source |
|------|------|--------|
| Web SG | 80, 443, 22 | 0.0.0.0/0 |
| App SG | 3001, 22 | Web SG only |
| DB SG  | 3306 | App SG only |

## Error Handling
- t2.micro unavailable → use t3.micro
- RDS unavailable → use db.t3.micro
- ALB needs 2 AZs → always pass 2 subnet IDs
- RDS needs subnet group → create before RDS instance
- SSH key missing → generate with ssh-keygen first