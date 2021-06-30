# azure-k8s-service demo
 

terraform init
terraform plan -refresh=true 
terraform apply -auto-approve


az aks start --resource-group k8s-demo-resources --name k8s-cluster-01
az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01