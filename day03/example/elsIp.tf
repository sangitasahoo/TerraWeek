# resource "aws_eip" "web" {
#   instance = aws_instance.web.id

#   tags = {
#     Name = "${var.name_prefix}-eip"
#   }
# }