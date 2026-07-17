# # Root module: resolve shared lookups ONCE, then call our reusable module.

# # --- Shared data sources (resolved a single time, passed into every module) ---

# data "aws_ami" "al2023" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }
# }

# # This example uses your account's DEFAULT VPC for convenience.
# # ⚠️ Prerequisite: a default VPC must exist in this region. If it was deleted,
# # either recreate it (`aws ec2 create-default-vpc`) or point subnet_id /
# # vpc_security_group_ids at the VPC you built on Day 3.
# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# data "aws_security_group" "default" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "default"
# }

# locals {
#   subnet_id          = data.aws_subnets.default.ids[0]
#   security_group_ids = [data.aws_security_group.default.id]
# }

# # 1) A single instance — pass inputs, read outputs.
# module "web_server" {
#   source                 = "./modules/ec2_instance"
#   name                   = "web"
#   instance_type          = "t3.micro"
#   environment            = "dev"
#   ami                    = data.aws_ami.al2023.id
#   subnet_id              = local.subnet_id
#   vpc_security_group_ids = local.security_group_ids

#   tags = {
#     Role = "frontend"
#   }
# }

# # 2) Modular composition: the SAME module, instantiated many times with for_each.
# module "servers" {
#   source   = "./modules/ec2_instance"
#   for_each = toset(["app", "worker", "cache"])

#   name                   = each.key
#   instance_type          = "t3.micro"
#   environment            = "dev"
#   ami                    = data.aws_ami.al2023.id
#   subnet_id              = local.subnet_id
#   vpc_security_group_ids = local.security_group_ids
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "= 5.1.2"   # ✅ always pin registry/git module versions

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"
  enable_flow_log = true
}

# # module "vpc" {
# #   source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.21.0"
# # }

# module "vpc" {
#   source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=22ccfa1730f86711ebf530b765c998a54db304bb"
# }