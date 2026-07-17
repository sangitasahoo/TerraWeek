# Day 6 - Terraform Learning Notes

**Date:** _(Add today's date)_

## Overview

Today I learned how to improve Terraform projects by using workspaces, testing, security scanning, cost estimation, CI/CD automation, and infrastructure best practices. These practices help make Terraform code more reliable, secure, maintainable, and production-ready.

---

# Task 1: Workspaces & Environments

## What are Terraform Workspaces?

Terraform workspaces allow multiple environments to use the same Terraform configuration while maintaining separate state files.

Each workspace has its own Terraform state.

Common environments:

- default
- dev
- staging
- prod

## Workspace Commands

List workspaces:

```bash
terraform workspace list
```

Create a workspace:

```bash
terraform workspace new staging
```

Switch workspace:

```bash
terraform workspace select staging
```

Show current workspace:

```bash
terraform workspace show
```

<img width="541" height="248" alt="image" src="https://github.com/user-attachments/assets/d141fb2a-7a09-4dbc-9718-808d2b1051c8" />


## Using `terraform.workspace`

Terraform provides a built-in variable called `terraform.workspace`.

Example:

```hcl
locals {
  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t3.micro"
}
```

This allows different configurations based on the active workspace.

### Example

| Workspace | Instance Type |
|-----------|---------------|
| dev | t3.micro |
| staging | t3.micro |
| prod | t3.medium |

## Workspaces vs Separate Environments

### Workspaces

**Pros**

- Reuse the same Terraform code
- Separate state files
- Easy to switch environments
- Less code duplication

**Cons**

- Easy to deploy to the wrong workspace
- Limited flexibility
- Not ideal for large production environments

### Separate Directories/Backends

**Pros**

- Strong environment isolation
- Better for production
- Different backend configurations
- Better team collaboration

**Cons**

- More Terraform code to maintain

| Workspaces | Separate Directories/Backends |
|------------|-------------------------------|
| Same code, different state | Separate code and state |
| Easy for small projects | Better for production |
| Quick to switch | More secure and isolated |

---

**Summary:**
- **Workspaces** → Best for small/simple projects.
- **Separate directories/backends** → Best for production projects.

# Task 2: Quality Gates

Quality gates ensure Terraform code is correct before deployment.

## Format Terraform Code

```bash
terraform fmt -recursive
```

Purpose:

- Formats Terraform files
- Improves readability
- Keeps code style consistent

---

## Validate Configuration

```bash
terraform validate
```
<img width="349" height="77" alt="image" src="https://github.com/user-attachments/assets/06327ac3-a5d4-4975-8c51-9584104c6ab5" />


Checks:

- Syntax
- Variable references
- Resource arguments
- Module references

Does **not** create infrastructure.

---

## Native Terraform Testing

Terraform 1.6 introduced native testing.

Run tests:

```bash
cd example

terraform init

terraform test
```

Example test:

```hcl
run "plan_test" {
  command = plan

  assert {
    condition = true
  }
}
```

## Plan vs Apply Tests

### Plan-based Test

- Runs `terraform plan`
- Creates no resources
- Fast
- Ideal for CI

### Apply-based Test

- Runs `terraform apply`
- Creates real resources
- Verifies actual infrastructure
- Automatically destroys test resources after completion

---

### **Tearing Down**

- **Tearing down** means Terraform is **cleaning up (destroying)** the resources created during the test.
- It happens after the tests finish to keep the environment clean and avoid unnecessary costs.

**Example:**
`terraform test` → Create resources → Run tests → **Tear down (destroy resources)**.

During `terraform test`, Terraform creates a temporary testing environment.

<img width="373" height="165" alt="image" src="https://github.com/user-attachments/assets/59bf0fd1-3317-4eaa-80e6-565e51da2d42" />


For plan tests:

- Removes temporary state
- Removes temporary files

For apply tests:

- Destroys resources created during testing
- Cleans temporary state

---

# Task 3: Security & Cost Scanning

## Trivy Security Scanner

Run:

```bash
trivy config .
```
<img width="1044" height="395" alt="image" src="https://github.com/user-attachments/assets/1ce5a384-b49c-435a-a169-658a872d988f" />

Purpose:

- Detect security issues
- Detect Terraform misconfigurations
- Suggest best practices

<img width="1078" height="350" alt="image" src="https://github.com/user-attachments/assets/fa81598b-13ea-495c-9aef-0c9c7be09b02" />


### Finding I Received

```
AWS-0178

VPC does not have VPC Flow Logs enabled.
```

Meaning:

The VPC should have Flow Logs enabled to monitor network traffic.

Benefits:

- Network visibility
- Security monitoring
- Compliance
- Troubleshooting

Possible fix:

```hcl
enable_flow_log = true
```

Do **not** modify files inside:

```
.terraform/modules/
```

Always update your own Terraform module configuration.

---

## Infracost

Estimate cloud costs before deployment.

Commands:

```bash
terraform plan -out=tfplan

terraform show -json tfplan > plan.json

infracost breakdown --path plan.json
```

Benefits:

- Predict monthly costs
- Compare infrastructure changes
- Prevent unexpected expenses

---

# Task 4: CI/CD with GitHub Actions

| Step | What it Does |
|------|---------------|
| **`terraform fmt -check`** | Checks if Terraform files are properly formatted. |
| **`terraform init`** | Downloads the required providers and modules. |
| **`terraform validate`** | Checks the Terraform code for syntax and configuration errors. |
| **`terraform plan`** | Shows what changes Terraform will make without creating or modifying any resources. |

Terraform can automatically validate infrastructure whenever code is pushed or a Pull Request is opened.

Workflow location:

```
.github/workflows/terraform.yml
```

Typical pipeline:

<img width="1464" height="450" alt="image" src="https://github.com/user-attachments/assets/c6b9834b-122b-46a1-b131-69c0a037f656" />


```
Checkout Repository
↓

Install Terraform
↓

terraform fmt -check
↓

terraform init
↓

terraform validate
↓

terraform plan
```

## Explanation of Each Step

### Checkout

Downloads the repository onto the GitHub runner.

### Setup Terraform

Installs Terraform CLI.

### terraform fmt -check

Checks formatting.

Fails if formatting is incorrect.

### terraform init

Downloads:

- Providers
- Modules

Initializes Terraform.

### terraform validate

Checks configuration correctness.

### terraform plan

Shows infrastructure changes without applying them.

---

# Task 5: Terraform Best Practices

- ✅ **Remote state** – Store the state remotely and never commit `.tfstate` files.
- ✅ **Version pinning** – Pin Terraform, provider, and module versions.
- ✅ **Reusable modules** – Use modules to avoid repeating code and keep naming/tagging consistent.
- ✅ **No hard-coded secrets** – Use variables, environment variables, or a secrets manager.
- ✅ **CI checks** – Run `fmt`, `validate`, `test`, and a security scan (like Trivy).
- ✅ **README & cleanup** – Keep a clear `README.md` and use `terraform destroy` to remove resources when done.

## Remote State

- Store Terraform state remotely
- Enable state locking
- Never commit `.tfstate`

Example backend:

```hcl
backend "s3" {
  bucket = "terraform-state"
  key    = "terraform.tfstate"
}
```

---

## Version Pinning

Always pin:

- Terraform version
- Provider version
- Module version

Example:

```hcl
terraform {
  required_version = "~> 1.9"
}
```

---

## Reusable Modules

Instead of writing everything in one file:

```
modules/

ec2_instance/

security_group/

vpc/
```

Modules improve:

- Reusability
- Maintainability
- Organization

---

## Consistent Naming & Tags

Example:

```hcl
tags = {
  Name        = "web-server"
  Environment = "dev"
  Owner       = "Sangita"
}
```

Benefits:

- Easier management
- Better cost tracking
- Better organization

---

## No Hard-coded Secrets

Avoid:

```hcl
password = "MyPassword123"
```

Instead:

```hcl
variable "db_password" {
  sensitive = true
}
```

Use:

- Environment variables
- `.tfvars`
- AWS Secrets Manager

---

## CI Quality Gates

Run automatically:

```bash
terraform fmt

terraform validate

terraform test

trivy config .
```

Ensures:

- Formatting
- Validation
- Testing
- Security

---

## README

Every Terraform project should include:

- Project description
- Prerequisites
- Setup instructions
- Deployment commands
- Destroy instructions

---

## Destroy Infrastructure

Always verify infrastructure can be removed.

```bash
terraform destroy
```

This prevents unnecessary cloud costs.

---

# Key Commands Learned Today

```bash
terraform workspace list
terraform workspace new staging
terraform workspace select staging
terraform workspace show

terraform fmt -recursive
terraform validate
terraform test

trivy config .

terraform plan -out=tfplan
terraform show -json tfplan > plan.json

infracost breakdown --path plan.json

terraform destroy
```

---

# Key Takeaways

- Terraform workspaces isolate state for different environments.
- `terraform.workspace` allows environment-specific configuration.
- Use `terraform fmt`, `validate`, and `test` before deployment.
- Native Terraform tests help verify infrastructure behavior.
- Trivy detects security issues in Terraform configurations.
- Infracost estimates cloud costs before deployment.
- GitHub Actions automate formatting, validation, and planning on every pull request.
- Follow Terraform best practices such as remote state, version pinning, reusable modules, consistent tagging, and secure secret management.
- A well-documented project with a working `terraform destroy` is essential for maintainable infrastructure.
