# azure-k8s-service demo
 
Infrastructure>Azure klasörü içerisinde __terraform__ ile Azure Kubernetes Service içinde bir cluster oluşturmak için;
- terraform init
- terraform plan -refresh=true 
- terraform apply -auto-appove


Gerektiği zaman cluster'ı durdurup, tekrar başlatmak için;
```
az aks start --resource-group k8s-demo-resources --name k8s-cluster-01

az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01
```
