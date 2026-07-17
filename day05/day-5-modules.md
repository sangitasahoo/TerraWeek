# Day 5 -- Terraform Modules

## What is a Module?

A Terraform module is a collection of `.tf` files that work together to
provision a specific piece of infrastructure. Modules let you package
infrastructure into reusable building blocks.

A **module** is a reusable collection of Terraform configuration files (`.tf`) that creates and manages infrastructure resources.


### Root Module

The **root module** is the main Terraform configuration in the directory where you run commands like:
(The directory where you run)

``` bash
terraform init
terraform plan
terraform apply
terraform destroy
```

is called the **root module**.

### Child Module

A module called from another module.

Example:

``` hcl
module "web_server" {
  source = "./modules/ec2_instance"
}
```

------------------------------------------------------------------------

## Benefits of Modules

### Reusability

Write infrastructure once and reuse it in multiple projects.

### Consistency

Use the same infrastructure definition across Dev, QA, Staging and
Production.

### Encapsulation

Hide the implementation details inside the module and expose only: -
Input variables (`variables.tf`) - Outputs (`outputs.tf`)

The caller doesn't need to know how the resources are created
internally.

### Versioning

Pin module versions so everyone uses the same tested release.

### Testing

Modules can be tested independently before being reused.

**benifits:**
- Ensures **reproducible builds** by using the same module version every time.
- Prevents **unexpected breaking changes** from newer module versions.
- Keeps deployments **stable and consistent** across all environments.

------------------------------------------------------------------------

## Standard Module Structure

``` text
modules/
└── ec2_instance/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── README.md
```

-   **main.tf** -- Resources
-   **variables.tf** -- Inputs
-   **outputs.tf** -- Outputs
-   **README.md** -- Documentation

------------------------------------------------------------------------

# Writing and Using a Module

Project structure:

``` text
example/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── ec2_instance/
```

Root module:

``` hcl
module "web_server" {
  source                 = "./modules/ec2_instance"
  name                   = "web"
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}
```

Outputs are accessed as:

``` hcl
module.web_server.public_ip
```

------------------------------------------------------------------------

## Why Pass IDs Instead of Doing Lookups?

The root module performs data lookups once:

-   AMI
-   Subnet
-   Security Groups

Then passes their IDs to child modules.

Advantages: - Avoid repeated data source lookups - Faster plans - Better
reusability - Cleaner modules

------------------------------------------------------------------------

## terraform init with Modules

`terraform init`: - Downloads providers - Initializes local modules -
Downloads remote/registry modules - Creates `.terraform/` - Creates
`.terraform.lock.hcl`

<img width="576" height="367" alt="image" src="https://github.com/user-attachments/assets/ff14a64d-eae6-4d14-b8fb-857dacef472c" />

<img width="954" height="107" alt="image" src="https://github.com/user-attachments/assets/58eb781e-a80e-4db0-bf46-620a1df3b163" />

<img width="1059" height="268" alt="image" src="https://github.com/user-attachments/assets/65cb83e8-664b-4df8-8caa-5e3624ce6e8f" />


------------------------------------------------------------------------

## Registry Modules

Example:

``` hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"
}
```

`source` specifies where the module comes from.

`version` specifies which version Terraform should use.

------------------------------------------------------------------------

## Version Locking

### Registry

``` hcl
version = "~> 5.0"
```

Other constraints:

``` hcl
version = "= 5.1.2"
version = ">= 5.0"
version = "< 6.0"
```

<img width="604" height="189" alt="image" src="https://github.com/user-attachments/assets/ee3b972f-ff97-429b-8dca-a445134e73d4" />


### Git Tag

``` hcl
source = "git::https://github.com/org/repo.git//modules/vpc?ref=v1.2.0"
```

<img width="801" height="481" alt="image" src="https://github.com/user-attachments/assets/ab7ee8e0-04bb-4061-bdcd-00fc383c582b" />



### Git Commit SHA

``` hcl
source = "git::https://github.com/org/repo.git//modules/vpc?ref=<full-commit-sha>"
```

<img width="978" height="517" alt="image" src="https://github.com/user-attachments/assets/3749707a-2e89-4235-9f40-3a652df930a4" />


Using a full commit SHA is the most reproducible because it is
immutable.

------------------------------------------------------------------------

## Why Version Pinning Matters

Without pinning: - Different developers may download different module
versions. - New releases may introduce breaking changes.

With pinning: - Reproducible builds - Consistent environments -
Predictable deployments - Controlled upgrades

------------------------------------------------------------------------

## Registry vs Local Modules

  Local Module              Registry Module
  ------------------------- ---------------------------------------
  Stored in your project    Downloaded from Terraform Registry
  Maintained by your team   Maintained by community/organizations
  No download               Downloaded during `terraform init`

------------------------------------------------------------------------

## Best Practices

-   Keep modules focused on one responsibility.
-   Resolve shared lookups in the root module.
-   Pass IDs into child modules.
-   Expose only required outputs.
-   Always document modules with a README.
-   Always pin Registry or Git module versions.
-   Prefer Git tags or full commit SHAs for Git modules.
