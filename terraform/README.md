# Terraform: VPC + EKS

Builds the network and the EKS cluster the shop runs on, as two environments from the same code.

The VPC and EKS modules started from the course project
[iam-veeramalla/ultimate-devops-project-aws](https://github.com/iam-veeramalla/ultimate-devops-project-aws) (Apache-2.0).
Changes on top of it:

- `dev` and `prod` environments from one codebase (`envs/*.tfvars`)
- Dev cost controls: a single shared NAT gateway and Spot node groups
- State in S3 with native locking (`use_lockfile`); no DynamoDB table, no state in git
- EKS access entries instead of hand-edited `aws-auth`
- OIDC provider for IRSA (used by the AWS Load Balancer Controller)
- Node labels, rolling update limits, and `desired_size` left to the autoscaler
- `fmt`, `validate`, `tflint` and `checkov` run on every pull request

## Layout

```
terraform/
├── bootstrap/        # one-time: S3 bucket for state
├── envs/             # <env>.tfvars + <env>.backend.hcl
├── modules/
│   ├── vpc/          # VPC, public/private subnets, NAT, routes
│   └── eks/          # cluster, node groups, IAM roles, OIDC
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

## Usage

```bash
# 1. State bucket (once)
terraform -chdir=terraform/bootstrap init
terraform -chdir=terraform/bootstrap apply -var bucket_name=<unique-name>

# 2. Put that bucket name in envs/dev.backend.hcl, then:
cd terraform
terraform init -backend-config=envs/dev.backend.hcl
terraform plan  -var-file=envs/dev.tfvars -out dev.tfplan
terraform apply dev.tfplan

# 3. Connect kubectl
$(terraform output -raw kubeconfig_command)

# Tear down when done (EKS and NAT gateways bill by the hour)
terraform destroy -var-file=envs/dev.tfvars
```

Switch environments with `terraform init -reconfigure -backend-config=envs/prod.backend.hcl`.
