data "aws_vpc" "current" {
  tags = {
    Environment = var.environment
  }
}

data "aws_availability_zones" "current" {}

data "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id = data.aws_vpc.current.id
  tags = {
    Name = "${var.environment}-private-${each.key}"
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.current.names)

  vpc_id = data.aws_vpc.current.id
  tags = {
    Name = "${var.environment}-public-${each.key}"
  }
}