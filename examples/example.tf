provider "aws" {
  region = "us-east-1"
}

module "vpc-peering" {
  source = "../"

  name        = "vpc-peering"
  environment = "test"
  label_order = ["environment", "name"]

  enable_peering    = true
  accepter_role_arn = "arn:aws:iam::xxxxxxxxx:role/switch-role"
  accepter_region   = "us-east-1"
  requestor_vpc_id  = "vpc-xxxxxxxxxxxx"
  acceptor_vpc_id   = "vpc-xxxxxxxxxxxx"
}
