resource "aws_subnet" "main" {
    vpc_id = var.vpc_id
    availability_zone = var.az
    cidr_block = var.cidr
    tags = {
        Name = var.name
    }
}