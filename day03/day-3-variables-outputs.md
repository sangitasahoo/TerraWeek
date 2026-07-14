# Day 63 -- Terraform Variables, Outputs, Providers, Data Sources & Meta-Arguments

## Objective

Today I learned how Terraform configurations become reusable and
production-ready by using variables, outputs, provider version
constraints, data sources, and meta-arguments.

## Task 1 -- Providers & Version Pinning

A provider is a plugin that allows Terraform to communicate with
platforms like AWS, Azure, Docker, Kubernetes, etc.

``` hcl
terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

### Why Version Pinning Matters

-   Keeps deployments consistent.
-   Prevents unexpected breaking changes.
-   Ensures every developer and CI/CD pipeline uses compatible versions.

### Understanding `~>`

-   `~> 6.0` → Allows all `6.x` releases but not `7.0`.
-   `~> 6.2.1` → Allows only `6.2.x` patch releases.

### Provider Alias

``` hcl
provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "secondary"
  region = "ap-south-2"
}
```

### When would you use a Provider Alias?

-   To create resources in **multiple AWS regions** (e.g., `us-west-2`
    and `us-east-1`).
-   To manage **multiple AWS accounts** in the same Terraform project.
-   To use different provider configurations for **Dev**, **QA**, and
    **Production** environments.

------------------------------------------------------------------------

## Task 2 -- Resources vs Data Sources

### Resource

Resources create and manage infrastructure.

``` hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}
```

### Data Source

``` hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}
```

### Difference

-   **Resources** create and manage infrastructure (e.g., EC2, VPC,
    Subnet).
-   **Data sources** only read existing information (e.g., AMI,
    Availability Zones) and do not create anything.

------------------------------------------------------------------------

## Task 3 -- Variables & Outputs

Variables make configurations reusable.

``` hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

Outputs display useful values after deployment.

``` hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

Variable values can come from: - terraform.tfvars - \*.auto.tfvars -
`-var` - Environment variables

------------------------------------------------------------------------

## Task 4 -- Meta Arguments

### count

Creates multiple identical resources.

``` hcl
count = 3
```

### for_each

Creates resources from a map or set.

``` hcl
for_each = local.instances
```

Preferred over `count` for named resources.

### depends_on

Forces Terraform to create resources in a specific order.

``` hcl
depends_on = [aws_s3_bucket.logs]
```

### lifecycle

``` hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
  ignore_changes        = [tags["LastModified"]]
}
```

-   **create_before_destroy**: Create replacement before deleting the
    old resource.
-   **prevent_destroy**: Protect critical resources from accidental
    deletion.
-   **ignore_changes**: Ignore updates to selected attributes made
    outside Terraform.

------------------------------------------------------------------------

## Important Terraform Files

  File                Purpose
  ------------------- ----------------------
  main.tf             Infrastructure
  variables.tf        Variable definitions
  terraform.tfvars    Variable values
  outputs.tf          Outputs
  terraform.tfstate   State file

------------------------------------------------------------------------

## Commands Practiced

``` bash
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

## Key Learnings

-   Configured providers with version constraints.
-   Learned version pinning and the `~>` operator.
-   Used provider aliases.
-   Understood resources vs data sources.
-   Used variables and outputs.
-   Practiced `count`, `for_each`, `depends_on`, and `lifecycle`.
