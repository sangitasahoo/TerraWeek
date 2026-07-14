# Day 2 – Terraform Providers & Resources

## Overview
Today I learned the core building blocks of Terraform configurations:
- HCL syntax
- Blocks, arguments, and expressions
- Variables and data types
- Variable validation
- Locals
- Outputs
- Built-in functions
- Using the Docker provider
- Terraform workflow (`init`, `plan`, `apply`, `output`, `destroy`)
- Using `terraform.tfvars`

## 1. HCL Syntax

General block syntax:

```hcl
block_type "label_one" "label_two" {
  argument = value
}
```

Example:

```hcl
resource "docker_container" "web" {
  name  = "tws-web"
  image = docker_image.nginx.image_id
}
```

### Arguments vs Blocks

Arguments assign values:

```hcl
instance_type = "t2.micro"
```

Blocks create nested configuration:

```hcl
ingress {
  from_port = 80
}
```

## 2. Expressions

### String interpolation

```hcl
name = "web-${var.environment}"
```

### References

```hcl
aws_vpc.main.id
var.project_name
local.name_prefix
module.network.vpc_id
```

### Operators

- Arithmetic: `+ - * / %`
- Comparison: `== != > < >= <=`
- Logical: `&& || !`
- Conditional:

```hcl
var.environment == "prod" ? "t3.large" : "t2.micro"
```

---

## 3. Variables

### Primitive types

```hcl
string
number
bool
```

### Collection types

```hcl
list(string)
map(string)
set(string)
```

Difference between List and Set:

| List | Set |
|------|-----|
| Ordered | Unordered |
| Duplicates allowed | Duplicates removed |
| Access by index | No index access |

### Structural types

```hcl
object({...})
tuple([...])
```

## 4. Variable Validation

Example:

```hcl
validation {
  condition = contains(["dev","staging","prod"], var.environment)
  error_message = "environment must be one of: dev, staging, prod."
}
```

Learned:
- `condition` must return `true` or `false`.
- `contains()` checks if a value exists in a list.
- Terraform stops execution and shows `error_message` when validation fails.

---

## 5. Locals

Locals store computed values.

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}
```

Access:

```hcl
local.name_prefix
```

I also learned to use `merge()` to combine multiple tag maps.

---

## 6. Outputs

Outputs display useful values after `terraform apply`.

```hcl
output "container_name" {
  value = var.container_name
}
```

Useful for:
- Resource IDs
- Public IPs
- Container names
- Computed values

---

## 7. Built-in Functions

Functions explored:

```hcl
upper("terraweek")
```

Result:

```
TERRAWEEK
```

```hcl
merge({a=1},{b=2})
```

```hcl
join("-",["tws","terraweek","2026"])
```

```hcl
lookup({dev="t2.micro"},"dev","not found")
```

```hcl
length(["dev","prod"])
```

```hcl
format("%s-%d","server",1)
```

Used `terraform console` to test these functions interactively.

---

## 8. Docker Provider Project

Worked with the `kreuzwerker/docker` provider.

Terraform workflow:

```bash
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

Created an Nginx container driven entirely by variables.

Verified the application by opening:

```
http://localhost:8080
```

---

## 9. Passing Variables

### Using `-var`

```bash
terraform apply \
-var="container_name=tws-web" \
-var="external_port=8080"
```

### Using `terraform.tfvars`

```hcl
container_name = "tws-web"
external_port  = 8080
```

Then simply run:

```bash
terraform apply
```

### Difference

Both methods produce the same infrastructure when the values are identical.

The difference is:
- `-var` is suitable for temporary or one-time values.
- `terraform.tfvars` keeps configuration organized and avoids repeatedly typing variables.
- If the file is named exactly `terraform.tfvars`, Terraform loads it automatically.
- For custom names such as `dev.tfvars`, use:

```bash
terraform apply -var-file="dev.tfvars"
```

---

## Commands Practiced

```bash
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
terraform console
terraform plan -var-file="terraform.tfvars"
```

---

## Key Takeaways

- Terraform configurations are written in HCL.
- Blocks define infrastructure, while arguments configure it.
- Variables make configurations reusable.
- Validation prevents invalid user input.
- Locals reduce repetition.
- Outputs expose important information after deployment.
- Built-in functions simplify data manipulation.
- Providers allow Terraform to manage external platforms such as Docker and AWS.
- Resources represent the infrastructure objects Terraform creates.
- `terraform.tfvars` is the preferred way to manage project-specific variables.
- `terraform console` is useful for experimenting with expressions and functions.
