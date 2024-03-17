terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [ aws.requestor, aws.acceptor ]
    }
  }
}

variable "env" {}

data "aws_vpc" "requestor_vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.env}_VPC"]
  }
}

variable "tags" {}

variable "aws_region_acceptor_id" {}

variable "acceptor_vpc_id" {}


data "aws_route_tables" "requestor" {
  provider = aws.requestor
  vpc_id = data.aws_vpc.requestor_vpc.id
}

data "aws_vpc" "acceptor" {
    provider = aws.acceptor
    id = var.acceptor_vpc_id
}

data "aws_route_tables" "acceptor" {
  provider = aws.acceptor
  vpc_id = data.aws_vpc.acceptor.id
}

data "aws_caller_identity" "peer" {
  provider = aws.acceptor
}