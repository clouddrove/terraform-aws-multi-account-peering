provider "aws" {
  region = "us-east-1"
}

module "vpc-peering" {
  source = "../"

  name        = "vpc-peering"
  environment = "test"
  label_order = ["environment", "name"]

  enable_peering    = true
  accepter_role_arn = "arn:aws:iam::750949624929:role/crossacc"
  accepter_region   = "us-east-1"
  requestor_vpc_id  = "vpc-097ecd4fed78ec692"
  acceptor_vpc_id   = "vpc-0cd2de425b3d865e9"
}
