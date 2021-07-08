# Azure Kubernetes Service demo

Bu repository'de [Azure Kubernetes Service ile tanışalım](https://www.minepla.net/2020/08/azure-kubernetes-service-ile-tanisalim/) blog yazısında anlatılan Azure Kubernetes Service ile ilgili örnekleri bulabilirsiniz.

-------------------------------------------------------------------------------

## Güncelleme
Bu repo.'ya ev sahipliği yapan yazıda, k8s için gerekli olan bileşenleri, Azure'da portal dışında __terraform__ gibi "infra-as-code" konsepti ile de oluşturabileceğimizi belirtmiştim. Kodlar arasında **_infrastructure/azure_** klasörü içinde Azure Kubernetes Service için örnek olabilecek kodları görebilirsiniz.

- **_[infrastructure/azure](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/infrastructure/azure)_** klasörü içerisinde _terraform_ ile Azure Kubernetes Service içinde bir cluster oluşturmak için sırasıyla:
  - terraform init
    - _"state"_ dosyasını Azure Storage'da tutabilmek için
       ``` 
       terraform init -backend=true -backend-config storage_account_name="k8sdemoresourcestfstate" -backend-config container_name="terraform-states" -backend-config access_key="" -backend-config key="terraform.tfstate"
       ```
       *Bu sayede terraform tarafında yapılmış değişiklikleri başka bir kişi de bu _state_ dosyası üzerinde çalışarak yapabilir.
  - terraform plan -refresh=true 
  - terraform apply -auto-approve

- [GitHub CodeSpace](https://github.com/features/codespaces) üzerinden geliştirme yapabilmek için, __terraform__, GitHub CodeSpace içerisinde kurulmalı:
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform -help  !!Terraform'un başarılı bir şekilde kurulduğunu anlamak için)!!
terraform -install-autocomplete !!Opsiyonel - terraform geliştirmelerini daha kolay yapmak için!!
```

#### AKS'de **"kubernetes cluster"**'ını yönetebilmek için temel bazı komutlar
- Gerektiği zaman cluster'ı durdurup, tekrar başlatmak için
```
az aks start --resource-group k8s-demo-resources --name k8s-cluster-01

az aks stop --resource-group k8s-demo-resources --name k8s-cluster-01
```

- AKS üzerindeki cluster'ı yönetebilmek için AKS CLI'ı yüklemek için
```
az aks install-cli
```

- Cluster'a bağlanmak için ve kubectl komutlarının AKS için çalışmasını sağlamak için
```
az aks get-credentials --resource-group "k8s-demo-resources" --name "k8s-cluster-01"
```

- Cluster'daki node'ları listelemek için
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

- "namespace"'de sertifika validasyonun(Issuer kontrolü) kapatılması
```
kubectl label namespace ingress-default cert-manager.io/disable-validation=true
```

- cert-manager'ı **helm**'e eklemek için
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

- **cert-manager** yüklemek için
```
helm install cert-manager jetstack/cert-manager \
  --namespace ingress-default \
  --set installCRDs=true \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set webhook.nodeSelector."kubernetes\.io/os"=linux \
  --set cainjector.nodeSelector."kubernetes\.io/os"=linux
```

- NGINX **ingress controller**'ın IP'sini almak için*
```
kubectl get services -n ingress-default
kubectl -n ingress-default get svc nginx-ingress-ingress-nginx-controller -o json | jq .status.loadBalancer.ingress[0].ip
```
<sub>* IP'i bir domain ile ilişkilendirmek için kullanabiliriz</sub>

- Ingress'i oluşturmak için
```
kubectl apply -f k8s/azure_aks/ingress_frontend.yaml
```
<sub>* Blog yazısında Azure DevOps üzerinden basitçe kubectl komutlarını çalıştırıyorduk. Ama konsoldan da bütün _service, pod...vs._ tanımları çalıştırılabilir.</sub>


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
