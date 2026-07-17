# variable "user_name" {
#     description = "This is my 1st user"
#     default =  "Neha"
#     type = string 
# }

# variable "user_id" {
#     description = "This is the user ID"
#     default = 12345
#     type = number
# }

# variable "user_valid" {
#     description = "Check the user is valid or not"
#     default = true
#     type = bool
# }

# # List of Strings
# variable "users_reg_id" {
#   description = "List of all users reg. id"
#   type        = list(string)

#   default = [
#     "usr-dev-100",
#     "usr-dev-101",
#     "usr-dev-102"
#   ]
# }

# # Map of Strings
# variable "user_details" {
#   description = "Employee details"
#   type        = map(string)

#   default = {
#     Enmployee_name = "Sangita"
#     designation       = "DevOps"
#     Project     = "Terraform Automation"
#   }
# }

# # Set of Strings
# variable "allowed_id" {
#   description = "Unique allowed numbers"
#   type        = set(string)

#   default = [
#     "1001",
#     "2022",
#     "0080"
#   ]
# }

# # Object
# variable "instance_config" {
#   description = "EC2 instance configuration"

#   type = object({
#     instance_type = string
#     ami_id        = string
#     volume_size   = number
#     monitoring    = bool
#   })

#   default = {
#     instance_type = "t2.micro"
#     ami_id        = "ami-123456789"
#     volume_size   = 20
#     monitoring    = true
#   }
# }

# # Tuple
# variable "server_info" {
#   description = "Server information"

#   type = tuple([
#     string,
#     number,
#     bool
#   ])

#   default = [
#     "web-server",
#     8080,
#     true
#   ]
# }

# # Sensitive Variable
# variable "db_password" {
#   description = "Database password"
#   type        = string
#   sensitive   = true
# }

# # Validation Block
# variable "port" {
#   type = number

#   validation {
#     condition     = var.port >= 1 && var.port <= 65535
#     error_message = "Port must be between 1 and 65535."
#   }
# }
