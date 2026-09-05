resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr_block

  tags = merge(var.common_tags, {
    Name = "three-tier-vpc"
  })

}