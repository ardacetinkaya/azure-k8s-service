# azure-k8s-service demo

Bu repository [Azure Kubernetes Service ile tanışalım](https://www.minepla.net/2020/08/azure-kubernetes-service-ile-tanisalim/) blog yazısında anlatılan içeriğe ev sahipliği yapıyor. 

Azure Kubernetes Service üzerinde bir "cluster"'ı __terraform__ ile de basitçe yaratabilmek de mümkün.

GitHub CodeSpace üzerinden geliştirme yapabilmek için, __terraform__ CodeSpace de kurulmalı;
- curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
- sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
- sudo apt-get update && sudo apt-get install terraform
- terraform -help (Terraform'un başarılı bir şekilde kurulduğunu anlamak için)
- (optional)terraform -install-autocomplete

Infrastructure>Azure klasörü içerisinde __terraform__ ile Azure Kubernetes Service içinde bir cluster oluşturmak için;
- terraform init
  - __state__ dosyasını Azure Storage'da tutabilmek için;
     - terraform init -backend=true -backend-config storage_account_name="k8sdemoresourcestfstate" -backend-config container_name="terraform-states" -backend-config access_key="" -backend-config key="terraform.tfstate"
- terraform plan -refresh=true 
- terraform apply -auto-approve


Gerektiği zaman cluster'ı durdurup, tekrar başlatmak için;
```
az aks start --resource-group k8s-demo-resources --name k8s-cluster-01

az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01
```


- __kubectl__ yüklemek için
```
az aks install-cli
```

- Cluster'a bağlanmak için;
```
az aks get-credentials --resource-group "k8s-demo-resources" --name "k8s-cluster-01"
```

- Cluster'daki node'ları liste
```
kubectl get nodes
```
- "namespace" yaratmak için
```
kubectl create namespace ingress-default
```

- NGINX Ingress yüklemek için
```
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-default \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
```
