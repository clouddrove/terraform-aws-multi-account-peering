provider "aws" {
  region = "eu-west-1"
}

module "vpc-peering" {
  source = "git::https://github.com/clouddrove/terraform-aws-multi-account-peering.git"

  name        = "vpc-peering"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  enable_peering    = true
  accepter_role_arn = "arn:aws:iam::XXXXXXXXXXXX:role/assume-role"
  accepter_region   = "eu-west-1"
  requestor_vpc_id  = "vpc-XXXXXXXXXXXXX"
  acceptor_vpc_id   = "vpc-XXXXXXXXXXXXX"
}



