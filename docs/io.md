## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accepter\_region | The region of acceptor vpc. | `string` | n/a | yes |
| accepter\_role\_arn | The Role ARN of accepter AWS account. | `string` | `""` | no |
| acceptor\_allow\_remote\_vpc\_dns\_resolution | Allow acceptor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requestor VPC. | `bool` | `true` | no |
| acceptor\_vpc\_id | Acceptor VPC ID. | `string` | n/a | yes |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| enable\_peering | Set to false to prevent the module from creating or accessing any resources. | `bool` | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove' | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| profile\_name | Name of aws profile. | `string` | `null` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-multi-account-peering"` | no |
| requestor\_allow\_remote\_vpc\_dns\_resolution | Allow requestor VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the acceptor VPC. | `bool` | `true` | no |
| requestor\_vpc\_id | Requestor VPC ID. | `string` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| accept\_status | The status of the VPC peering connection request. |
| connection\_id | VPC peering connection ID. |
| tags | A mapping of tags to assign to the resource. |
