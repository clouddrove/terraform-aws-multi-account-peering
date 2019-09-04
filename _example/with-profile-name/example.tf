provider "aws" {
  region = "eu-west-1"
}


module "vpc-peering" {
  source = "git::https://github.com/clouddrove/terraform-aws-multi-account-peering.git"

  name        = "vpc-peering"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  multi_peering    = true
  accepter_region  = "eu-west-1"
  accepter_profile = "clouddrove-prod"
  requestor_vpc_id = "vpc-XXXXXXXXXXXXXX"
  acceptor_vpc_id  = "vpc-XXXXXXXXXXXXXX"
}

