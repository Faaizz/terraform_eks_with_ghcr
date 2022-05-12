# Update kubectl
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) && \

# Setup AWS Load Balancer Controller
## Download policy document
export ARN=$(wget -O iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.3/docs/install/iam_policy.json |
jq '.Policy.Arn') && \

# Create IAM ServiceAccount
eksctl create iamserviceaccount \
  --cluster=<EKS_CLUSTER_NAME> \
  --region=<EKS_REGION> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=${ARN} \
  --override-existing-serviceaccounts \
  --approve && \

# Instal cert-manager on the cluster to inject certificate configurations
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.1.1/cert-manager.yaml && \

# Replace cluster name
export CLUSTER_NAME_REP='s/your-cluster-name/${CLUSTER_NAME}/g' && \
sed -i'.original' -e${CLUSTER_NAME_REP} controller-spec.yaml && \

# Apply config: Install the controller
kubectl apply controller-spec.yaml && \

# Setup Secret
kubectl create secret docker-registry \
  ghcr-secret --docker-server=ghcr.io \
  --docker-username=${GHUSER} \
  --docker-password=${GHPAT} && \

# Patch Service Account
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "ghcr-secret"}]}' 
