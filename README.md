# azure-k8s-service demo

Bu repository (Azure Kubernetes Service ile tanışalım)[https://www.minepla.net/2020/08/azure-kubernetes-service-ile-tanisalim/] blog yazısında anlatılan içeriğe ev sahipliği yapıyor.

GitHub CodeSpace üzerinden geliştirme yapabilmek için, __terraform__ CodeSpace de kurulmalı;
- curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
- sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
- sudo apt-get update && sudo apt-get install terraform
- terraform -help (Terraform'un başarılı bir şekilde kurulduğunu anlamak için)
- (optional)terraform -install-autocomplete

Infrastructure>Azure klasörü içerisinde __terraform__ ile Azure Kubernetes Service içinde bir cluster oluşturmak için;
- terraform init
- terraform plan -refresh=true 
- terraform apply -auto-appove


Gerektiği zaman cluster'ı durdurup, tekrar başlatmak için;
```
az aks start --resource-group k8s-demo-resources --name k8s-cluster-01

az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01
```
