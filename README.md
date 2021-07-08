# Azure Kubernetes Service demo

Bu repository'de [Azure Kubernetes Service ile tanışalım](https://www.minepla.net/2020/08/azure-kubernetes-service-ile-tanisalim/) blog yazısında anlatılan Azure Kubernetes Service ile ilgili örnekleri bulabilirsiniz.

----------------------------------------------


Azure Kubernetes Service üzerinde bir "cluster"'ı __terraform__ ile de oluşturabilmenin de örnekleri mevcut.

- "infrastructure>azure" klasörü içerisinde __terraform__ ile Azure Kubernetes Service içinde bir cluster oluşturmak için sırasıyla:
  - terraform init
    "state" dosyasını Azure Storage'da tutabilmek için
       ``` 
       terraform init -backend=true -backend-config storage_account_name="k8sdemoresourcestfstate" -backend-config container_name="terraform-states" -backend-config access_key="" -backend-config key="terraform.tfstate"
       ```
  - terraform plan -refresh=true 
  - terraform apply -auto-approve

- GitHub CodeSpace üzerinden geliştirme yapabilmek için, __terraform__, GitHub CodeSpace de kurulmalı:
  - curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  - sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  - sudo apt-get update && sudo apt-get install terraform
  - terraform -help (Terraform'un başarılı bir şekilde kurulduğunu anlamak için)
  - (optional)terraform -install-autocomplete


## Azure Kubernetes Service'deki cluster'ı yönetebilmek için temel bazı komutlar
- Gerektiği zaman cluster'ı durdurup, tekrar başlatmak için
```
az aks start --resource-group k8s-demo-resources --name k8s-cluster-01

az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01
```

- AKS üzerindeki cluster'ı yönetebilmek için AKS CLI'ı yüklemek için
```
az aks install-cli
```

- Cluster'a bağlanmak için ve kubectl komutlarının Azure Kubernetes Service'i için çalışmasını sağlamak için
```
az aks get-credentials --resource-group "k8s-demo-resources" --name "k8s-cluster-01"
```

- Cluster'daki node'ları aşağıdaki gibi listelediğimiz zaman AKS üzerindeki node'lar listelenir
```
kubectl get nodes
```

- Kubernetes içinde "namespace" yaratmak için(ingress-default adında bir namespace yaratılır)
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

- "namespace"'de sertifika validasyonu(Issuer kontrolü) yapılmasın
```
kubectl label namespace ingress-default cert-manager.io/disable-validation=true
```

- cert-manager'ı helm'e eklemek için
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

- cert-manager yüklemek için
```
helm install cert-manager jetstack/cert-manager \
  --namespace ingress-default \
  --set installCRDs=true \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set webhook.nodeSelector."kubernetes\.io/os"=linux \
  --set cainjector.nodeSelector."kubernetes\.io/os"=linux
```

- NGINX ingress controller'ın IP'sini almak için
```
kubectl get services -n ingress-default
kubectl -n ingress-default get svc nginx-ingress-ingress-nginx-controller -o json | jq .status.loadBalancer.ingress[0].ip
```

- Ingress'i oluşturmak için
```
kubectl apply -f k8s/ingress_frontend.yaml
```

- Sertifika kontrolleri
```
kubectl get certificates
kubectl get certificaterequests.cert-manager.io 
kubectl describe certificate www-crt
kubectl delete certificate www-crt
```

# Bonus 

Amazon Elastic Kubernetes Service ile de k8s cluster'ı oluşturup, uygulamaları kolaylıkla farklı bir "cloud" platformunda da çalıştırabiliyoruz. Yine __terraform__ ile AWS tarafında gerekli bileşenleri oluşturmak için ""infrastructure>aws" klasörü içindeki kodlara bakabilirsiniz.
- AWS tarafındaki "resource" bileşenlerini bilmiyorum bu yüzden, __terraform__'da oluşturulmuş modülleri kullanıyorum.
  - k8s cluster'ının network alt yapısı için: https://github.com/terraform-aws-modules/terraform-aws-vpc
  - k8s cluster'ı için: https://github.com/terraform-aws-modules/terraform-aws-eks

- AWS CLI'ı kurmak için
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- AWS CLI'ın konfigürasyonu için
```
aws configure
```

- AWS CLI ile AWS EKS cluster'ına authenticate olabilmek için __aws-iam-authenticator__ kurulu gerekli --> https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
```
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
```

- kubectl ile AWS EKS cluster'ını ilişkilendir
```
aws sts get-caller-identity
aws eks --region {region} update-kubeconfig --name {cluster_name}
```
