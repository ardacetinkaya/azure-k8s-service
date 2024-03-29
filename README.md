# Azure Kubernetes Service demo

[![Build status](https://dev.azure.com/Miyop/LearningProjects/_apis/build/status/Kubernetes)](https://dev.azure.com/Miyop/LearningProjects/_build/latest?definitionId=14)
<img align="right" width="150" height="150" src="https://user-images.githubusercontent.com/4550197/125051903-18342780-e0ac-11eb-976b-99af7e9e2f9f.png">


Bu repository'de [Azure Kubernetes Service ile tanışalım](https://www.minepla.net/2020/08/azure-kubernetes-service-ile-tanisalim/) blog yazısında anlatılan Azure Kubernetes(k8s) Service(AKS) ile ilgili örnekleri bulabilirsiniz.

  - [Frontend tarafı için gerekli Deployment tanımı](https://github.com/ardacetinkaya/azure-k8s-service/blob/master/k8s/azure_aks/1_basic/frontend_service/service.yaml) - k8s
  - [Backend tarafı için gerekli Deployment tanımı](https://github.com/ardacetinkaya/azure-k8s-service/blob/master/k8s/azure_aks/1_basic/backend_service/service.yaml) - k8s
  - [ASP.NET Core Backend uygulaması](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/SampleAPI) - Docker imajlarının oluştuğu uygulama
  - [ASP.NET Core Forentend uygulaması](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/SampleApp) - Docker imajlarının oluştuğu uygulama


### ℹ Bu repository'de __AKS__ ve __Kubernetes(K8s)__ ile ilgili bazı konular ile ilgili temel basit örnekleri de zaman içerisinde eklemeye çalışacağım. k8s klasörü içerisinden takip edilebilir.


- [1_basic](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/k8s/azure_aks/1_basic)
- [2_ingress](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/k8s/azure_aks/2_ingress)
- [3_storage](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/k8s/azure_aks/3_storage)
- [4_configmap_secrets](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/k8s/azure_aks/4_configmap_secrets)
- [5_key_vault_provider_for_csi](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/k8s/azure_aks/5_key_vault_provider_for_csi)

-------------------------------------------------------------------------------

## ![Güncelleme](https://via.placeholder.com/15/1589F0/000000?text=+) Giriş
Bu repo.'ya ev sahipliği yapan yazıda, **k8s** için gerekli olan bileşenleri, Azure'da portal dışında __terraform__ gibi "infra-as-code" konsepti ile de oluşturabileceğimizi belirtmiştim. Kodlar arasında **_infrastructure/azure_** klasörü içinde Azure Kubernetes Service için örnek olabilecek kodları görebilirsiniz.

- **_[infrastructure/azure](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/infrastructure/azure)_** klasörü içerisinde _terraform_ ile Azure Kubernetes Service içinde bir cluster oluşturmak için sırasıyla:
  - ```terraform init```
    - _"state"_ dosyasını Azure Storage'da tutabilmek için
       ``` 
       terraform init -backend=true -backend-config storage_account_name="k8sdemoresourcestfstate" -backend-config container_name="terraform-states" -backend-config access_key="" -backend-config key="terraform.tfstate"
       ```
       *Bu sayede terraform tarafında yapılmış değişiklikleri başka bir kişi de bu _state_ dosyası üzerinde çalışarak yapabilir.
  - ```terraform plan -refresh=true``` 
  - ```terraform apply -auto-approve```

- [GitHub CodeSpace](https://github.com/features/codespaces) üzerinden geliştirme yapabilmek için, __terraform__, GitHub CodeSpace içerisinde kurulmalı:
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform -help  !!Terraform'un başarılı bir şekilde kurulduğunu anlamak için)!!
terraform -install-autocomplete !!Opsiyonel - terraform geliştirmelerini daha kolay yapmak için!!
```

Aynı zamanda k8s cluster'ını yönetmek ya da bazı bileşenleri oluşturmak için **_kubectl_** komutundan faydalanabiliyoruz. Benzer şekilde AKS için **_AZ CLI_** ile bazı işlemleri gerçekleştirebiliyoruz.

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
![image](https://user-images.githubusercontent.com/4550197/125045240-727dba00-e0a5-11eb-9e36-f77ec899897c.png)

- Bir pod'un içine girmek için
```
kubectl exec -it {pod_adı} -- /bin/bash
```

- Herhangi bir *pod*'u olmayan Replica Set'leri silmek için
```
kubectl delete replicaset $(kubectl get replicaset -o jsonpath='{ .items[?(@.spec.replicas==0)].metadata.name }')
```

- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)'de temel bazı komutları bulmak mümkün

- Docker imajlarını oluşturup ACR'e Push etmek için
```
az acr build --registry k8simagesregistery --image app:v1 .
```

-------------------------------------------------------------------------------
## ![!!!BONUS!!!😀](https://via.placeholder.com/15/c5f015/000000?text=+) !!!BONUS!!!😀 

Yeni bir şeyler öğrenmek çok zevkli. Bu yüzden **k8s**'i daha iyi anlamak, tecrübe edebilmek için farklı bir platform ile tanışmak da istedim. **AWS** üzerinde Kubernetes nasıl konumlandırılmış buna bakmaya çalıştım. Bundan dolayı bu **BONUS** ortaya çıktı.

**Amazon Elastic Kubernetes Service(AWS EKS)** ile yine benzer şekilde __terraform__ ile bir cluster nasıl oluşturulur, __k8s__ dinamiklikleri neler daha iyi öğrenmek için de fırsat. **Amazon Elastic Kubernetes Service(AWS EKS)** ile ilgili bilgiler için [buraya](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)... 


- **_[infrastructure/aws](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/infrastructure/aws)_** klasörü altında yine benzer terraform yaklaşımları ile ilerleyebiliyoruz.
  - AWS tarafındaki k8s için gerekli olabilecek "resource"'ları hiç bilmiyorum bu yüzden, **terraform**'daki modülleri tercih ettim;
    - k8s cluster'ının network alt yapısı için: https://github.com/terraform-aws-modules/terraform-aws-vpc
    - k8s cluster'ı için: https://github.com/terraform-aws-modules/terraform-aws-eks

- Benzer şekilde AWS EKS'de oluşturulmuş bir k8s cluster'ını yönetebilmek için yine **kubectl**'den faydalanabiliyoruz
- AWS CLI kullanarak komut satırından EKS cluster'ını yönetebiliyoruz.
  - AWS CLI'ı kurmak için
  ```
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ```

  - AWS CLI'ın konfigürasyonu için; AWS hesabı ile komut satırı komutlarının çalışmasını ilişkilendiriyoruz
  ```
  aws configure
  ```

  - AWS CLI ile AWS EKS cluster'ında yetkilendirilmek için __aws-iam-authenticator__ kurulumu gerekli --> https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
  ```
  curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator
  chmod +x ./aws-iam-authenticator
  mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
  echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
  ```

  - _kubectl_ ile AWS EKS cluster'ını ilişkilendiriyoruz ki, _kubectl_ komutlarımız EKS cluster'ı için çalışsın
  ```
  aws sts get-caller-identity
  aws eks --region {region} update-kubeconfig --name {cluster_name}
  ```
  
  
