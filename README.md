# Terraform EKS + GHCR
Terraform IaC Solution to Provision an AWS EKS Cluster with GitHub Container Registry.

This setup would serve to establish a container orchestration platform for Wayne-Yokohama Equity Partners (WYEP).

A cluster-specific VPC ensures isolation from other resources of the cloud network.

A provisioned ELB and AWS Load Balancer Controller allows load-balanced network connectivity. To create an ALB and the necessary supporting resources, an `Ingress` config should be annotated with:
```yaml
annotations:
    kubernetes.io/ingress.class: alb
```

## Requirements
- `terraform`
- `awscli` (configured to use a valid AWS account)
- `eksctl`
- `kubectl`
- `wget`
- `jq`
This config was setup on a Mac, if it is to be used on a linux computer, the `sed` command in `./external/setup.sh` must be corrected appropriately.

## Setup
To provision an AWS EKS cluster:
```bash
# Initialize terraform
terraform init
# Provision Infrastructure
terraform apply -var "gh_user=githubUsername" -var "gh_pat=githubPersonalAccessToken"
```
The properties of provisioned cluster can be tweaked by adjusting `./variables.tf` accordingly.
The variables has explanatory descriptions.
