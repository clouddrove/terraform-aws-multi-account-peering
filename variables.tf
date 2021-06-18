#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}


variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

#Module      : VPC PEERING
#Description : Terraform vpc peering module variables.
variable "accepter_region" {
  type        = string
  description = "The region of acceptor vpc."
}

variable "enable_peering" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating or accessing any resources."
}

variable "requestor_vpc_id" {
  type        = string
  description = "Requestor VPC ID."
}

variable "acceptor_vpc_id" {
  type        = string
  description = "Acceptor VPC ID."
}

variable "acceptor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC."
}

variable "requestor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC."
}

variable "accepter_role_arn" {
  type        = string
  default     = ""
  description = "The Role ARN of accepter AWS account."
}
variable "profile_name" {
  type        = string
  default     = null
  description = "Name of aws profile."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'"
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-multi-account-peering"
  description = "Terraform current module repo"
}
