# Infrastructure as a Code
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

## ![!!!BONUS!!!😀](https://via.placeholder.com/15/c5f015/000000?text=+) !!!BONUS!!!😀 

Yeni bir şeyler öğrenmek çok zevkli. Bu yüzden **k8s**'i daha iyi anlamak, tecrübe edebilmek için farklı bir platform ile tanışmak da istedim. **AWS** üzerinde Kubernetes nasıl konumlandırılmış buna bakmaya çalıştım. Bundan dolayı bu **BONUS** ortaya çıktı.

- **_[infrastructure/aws](https://github.com/ardacetinkaya/azure-k8s-service/tree/master/infrastructure/aws)_** klasörü altında yine benzer terraform yaklaşımları ile ilerleyebiliyoruz.
  - AWS tarafındaki k8s için gerekli olabilecek "resource"'ları hiç bilmiyorum bu yüzden, **terraform**'daki modülleri tercih ettim;
    - k8s cluster'ının network alt yapısı için: https://github.com/terraform-aws-modules/terraform-aws-vpc
    - k8s cluster'ı için: https://github.com/terraform-aws-modules/terraform-aws-eks
