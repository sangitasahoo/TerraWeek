# Day 4 – Terraform State Management

## Topics Covered

- Terraform state (`terraform.tfstate`)
- Why state matters
- State drift
- Sensitive information in state
- `terraform state` commands
- Importing existing resources
- `moved`, `removed`, and `check` blocks
- S3 bucket deletion and `force_destroy`

## What is Terraform State?

Terraform stores the current state of managed infrastructure in `terraform.tfstate`. It maps resources in your `.tf` files to the real infrastructure and stores IDs, attributes, outputs, dependencies, and metadata.

The `terraform.tfstate` file is automatically created when you run `terraform apply`.

It stores the current state of your infrastructure, including resources, data sources, and outputs. Terraform uses it to track and manage your infrastructure.

- The state file is **sensitive** because it can store secrets in plain text, such as passwords, API keys, and access tokens. Always keep it secure and never share it publicly.

### Why it is important

- Tracks created resources
- Determines create/update/delete actions
- Enables `plan` and `apply`
- Prevents duplicate resource creation

## Why you should never edit the state file

- Can corrupt state
- Terraform may lose track of resources
- May recreate or destroy the wrong infrastructure
- - **Never edit it by hand** because it can corrupt the state and cause Terraform to lose track of your infrastructure.

Use state commands instead:

```bash
terraform state list
terraform state show
terraform state mv
terraform state rm
terraform import
```

## Why you should not commit state to Git

- **Never commit it to Git** because it may contain sensitive information (such as IDs, IP addresses, or secrets) and can cause conflicts when multiple people work on the same infrastructure.

State files may contain:

- Resource IDs
- IP addresses
- Outputs
- Passwords or tokens (provider dependent)

Add to `.gitignore`:

```gitignore
*.tfstate
*.tfstate.*
```

Use remote backends (S3, Terraform Cloud, Azure Blob, GCS) for team projects.

## State Drift

- **State drift** happens when your actual infrastructure is changed outside of Terraform, so it no longer matches the Terraform state.

State drift occurs when infrastructure is changed outside Terraform.

Examples:
- Manual AWS Console changes
- AWS CLI changes
- Resource deletion outside Terraform

- `terraform plan` detects drift by comparing configuration, state, and real infrastructure.
- `terraform refresh` updates the state file to match the current infrastructure.

Modern Terraform automatically refreshes state during `plan` and `apply`.

## Terraform State Commands

### `terraform state list`
Lists all resources Terraform manages.


<img width="365" height="45" alt="image" src="https://github.com/user-attachments/assets/08f65c6a-a9bc-4b35-8c63-8a3b4eacd494" />


### `terraform state show <resource>`
Shows all stored attributes for one resource.

<img width="460" height="105" alt="image" src="https://github.com/user-attachments/assets/0389e579-96af-4c6f-a2f1-12905d482ef4" />


### `terraform state mv <src> <dest>`
Renames or moves a resource in state without recreating infrastructure.

<img width="623" height="199" alt="image" src="https://github.com/user-attachments/assets/2c5872b3-dade-400d-b89d-8211c73a6bd4" />


### `terraform state rm <resource>`
Removes a resource from state without deleting the real resource.


<img width="298" height="100" alt="image" src="https://github.com/user-attachments/assets/1bfe9841-7d26-4951-9234-2a64580e4d08" />


### `terraform show`
Displays the current state in a human-readable format.

<img width="483" height="101" alt="image" src="https://github.com/user-attachments/assets/43a5bf7e-a542-4a7e-bdf9-a75e83de0f4a" />


## Import Existing Resources (Terraform 1.5+)

Example:

```hcl
import {
  to = aws_s3_bucket.imported
  id = "my-manually-created-bucket"
}
```

<img width="701" height="660" alt="image" src="https://github.com/user-attachments/assets/1197e609-99cf-4783-a7bc-747fa4908a31" />


Generate configuration:

```bash
terraform plan -generate-config-out=generated.tf
```

Review `generated.tf`, then apply.

### Related Blocks

- `import` – Adopt existing infrastructure
- `moved` – Rename/move resources safely
- `removed` – Stop managing a resource
- `check` – Validate infrastructure assumptions

## Error Solved Today

### S3 BucketNotEmpty

During `terraform destroy`:

```
BucketNotEmpty: You must delete all versions in the bucket.
```

### Cause

The S3 bucket contained objects or versioned objects.

### Solution

Add:

```hcl
force_destroy = true
```

Then:

```bash
terraform apply
terraform destroy
```

If versioning is enabled, all object versions and delete markers must be removed before AWS deletes the bucket.

## Key Takeaways

- Terraform state is the source of truth for managed infrastructure.
- Never edit or commit state files.
- Use `terraform state` commands to inspect and manage state safely.
- Detect drift with `terraform plan`.
- Import existing resources using import blocks and generated configuration.
- Use `force_destroy` carefully when deleting non-empty S3 buckets.
