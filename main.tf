# Managed By : CloudDrove
# Description : This Script is used to manage a VPC peering connection of multiple account.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.13.0"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

#Accepter is AwS Details
provider "aws" {
  alias   = "accepter"
  region  = var.accepter_region
  version = ">= 1.25"
  profile = var.profile_name

  assume_role {
    role_arn = var.accepter_role_arn
  }
}

data "aws_caller_identity" "peer" {
  provider = "aws.accepter"
}

data "aws_region" "peer" {
  provider = "aws.accepter"
}


#Module      : VPC PEERING CONNECTION
#Description : Terraform module to connect two VPC's on AWS.
resource "aws_vpc_peering_connection" "default" {
  count         = var.enable_peering == true ? 1 : 0
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = data.aws_region.peer.id
  vpc_id        = var.requestor_vpc_id
  peer_vpc_id   = var.acceptor_vpc_id
  auto_accept   = false
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-%s", module.labels.application, module.labels.environment)
    }
  )
}

#Module      : VPC PEERING CONNECTION ACCEPTOR
#Description : Provides a resource to manage the accepter's side of a VPC Peering Connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  count                     = var.enable_peering == true ? 1 : 0
  provider                  = "aws.accepter"
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
  auto_accept               = true
  tags                      = module.labels.tags
}

#Module      : AWS VPC
#Description : Provides a VPC resource.
data "aws_vpc" "requestor" {
  count = var.enable_peering == true ? 1 : 0
  id    = var.requestor_vpc_id
}

#Module      : ROUTE TABLE
#Description : Provides a resource to create a VPC routing table.
data "aws_route_table" "requestor" {
  count = var.enable_peering == true ? length(distinct(sort(data.aws_subnet_ids.requestor[0].ids))) : 0

  subnet_id = element(
    distinct(sort(data.aws_subnet_ids.requestor[0].ids)),
    count.index
  )
}

#Module      : SUBNET ID's
#Description : Lookup requestor subnets.
data "aws_subnet_ids" "requestor" {
  count = var.enable_peering == true ? 1 : 0

  vpc_id = data.aws_vpc.requestor[0].id
}

#Module      : VPC ACCEPTOR
#Description : Lookup acceptor VPC so that we can reference the CIDR.
data "aws_vpc" "acceptor" {
  provider = "aws.accepter"
  count    = var.enable_peering == true ? 1 : 0
  id       = var.acceptor_vpc_id
}

#Module      : SUBNET ID's ACCEPTOR
#Description : Lookup acceptor subnets.
data "aws_subnet_ids" "acceptor" {
  provider = "aws.accepter"
  count    = var.enable_peering == true ? 1 : 0
  vpc_id   = data.aws_vpc.acceptor[0].id
}

#Module      : ROUTE TABLE
#Description : Lookup acceptor route tables.
data "aws_route_table" "acceptor" {
  provider = "aws.accepter"
  count    = var.enable_peering == true ? length(distinct(sort(data.aws_subnet_ids.acceptor[0].ids))) : 0

  subnet_id = element(
    distinct(sort(data.aws_subnet_ids.acceptor[0].ids)),
    count.index
  )
}

#Module      : ROUTE REQUESTOR
#Description : Create routes from requestor to acceptor.
resource "aws_route" "requestor" {

  count = var.enable_peering == true ? length(
    distinct(sort(data.aws_route_table.requestor.*.route_table_id))
  ) * length(data.aws_vpc.acceptor[0].cidr_block_associations) : 0

  route_table_id = element(
    distinct(sort(data.aws_route_table.requestor.*.route_table_id)),
    ceil(
      count.index / length(data.aws_vpc.acceptor[0].cidr_block_associations)
    )
  )

  destination_cidr_block    = data.aws_vpc.acceptor.0.cidr_block_associations[count.index % length(data.aws_vpc.acceptor[0].cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
  depends_on = [
    data.aws_route_table.requestor,
    aws_vpc_peering_connection.default,
  ]
}

#Module      : ROUTE ACCEPTOR
#Description : Create routes from acceptor to requestor.
resource "aws_route" "acceptor" {
  provider = "aws.accepter"

  count = var.enable_peering == true ? length(
    distinct(sort(data.aws_route_table.acceptor.*.route_table_id))
  ) * length(data.aws_vpc.requestor[0].cidr_block_associations) : 0

  route_table_id = element(
    distinct(sort(data.aws_route_table.acceptor.*.route_table_id)),
    ceil(
      count.index / length(data.aws_vpc.requestor[0].cidr_block_associations)
    )
  )

  destination_cidr_block    = data.aws_vpc.requestor.0.cidr_block_associations[count.index % length(data.aws_vpc.requestor[0].cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default[0].id
  depends_on = [
    data.aws_route_table.acceptor,
    aws_vpc_peering_connection.default,
  ]
}
