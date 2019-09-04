provider "aws" {
  region = "eu-west-1"
}


module "vpc-peering" {
  source = "git::https://github.com/clouddrove/terraform-aws-multi-account-peering.git"

  name        = "vpc-peering"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  account_peering  = true
  accepter_region  = "eu-west-1"
  account_id       = "9456810253026"
  requestor_vpc_id = "vpc-XXXXXXXXXXXXXXX"
  acceptor_vpc_id  = "vpc-XXXXXXXXXXXXXXX"
}
