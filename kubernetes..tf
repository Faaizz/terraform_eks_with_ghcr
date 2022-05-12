# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  provisioner "local-exec" {
      command = "./external/setup.sh"
      environment = {
          GHUSER = var.gh_user
          GHPAT = var.gh_pat
          CLUSTER_NAME = local.cluster_name
      }
  }
}
