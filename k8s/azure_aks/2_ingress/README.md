
# Ingress Controller - nginx

**Ingress Controllers**, cluster'a olan girişlerin kontrol edildiği ve sağlandığı yapı olarak düşünülebilir. Bu bağlamda Ingress Controller olarak **NGINX**'i, Azure Kubernetes Service'de nasıl kullanabiliriz kabaca bir örnek;


- Kubernetes içinde **namespace** yaratmak için(__ingress-default__ adında bir namespace yaratılır)
```
kubectl create namespace ingress-default
```
<sub>* kubernetes bileşenlerini mantıksal gruplar şeklinde yönetebilmek için __namespace__ kullanabiliyoruz.</sub>

- NGINX Ingress Controller'ını yüklemek için(İyi de _ingress_ ne?*)
```
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-default \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
```
<sub>* __ingress__, basitçe; Kubernetes'deki servislere dışarıdan erişmek için gerekli yönlendirmeleri yapabilmek için kullanılan yapı. Bu örneklerde **nginx**'i bu yönlendirmeler için kullabiliyoruz. AKS özelinde __Application Gateway__'de kullanılabilmekte. </sub>

<sub>* İlk blog yazısında direkt __ingress__ kullanmadan basit bir şekilde ilerlemiştim, burada __nginx Ingress Controller__ ile **pod**'lara gelen request'leri yönlendirmek mümkün olabiliyor.</sub>

### Direkt "Ingress Controller" ile alakası yok ama K8s cluster'ında sertifika yönetimi için cert-manager kullanabiliyoruz.
 
- cert-manager'ı **helm**'e eklemek için
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
<sub>* **helm**, k8s üzerindeki uygulamalar için bir paket yönetim aracı.</sub>

- **cert-manager** yüklemek için (bu sayede k8s üzerindeki sertifika yönetimlerini yapmak mümkün olabiliyor)
```
helm install cert-manager jetstack/cert-manager \
  --namespace ingress-default \
  --set installCRDs=true \
  --set nodeSelector."kubernetes\.io/os"=linux \
  --set webhook.nodeSelector."kubernetes\.io/os"=linux \
  --set cainjector.nodeSelector."kubernetes\.io/os"=linux
```

- "namespace"'de sertifika validasyonun(Issuer kontrolü) kapatılması
```
kubectl label namespace ingress-default cert-manager.io/disable-validation=true
```

- NGINX **ingress controller**'ın IP'sini almak için*
```
kubectl get services -n ingress-default
kubectl -n ingress-default get svc nginx-ingress-ingress-nginx-controller -o json | jq .status.loadBalancer.ingress[0].ip
```
![image](https://user-images.githubusercontent.com/4550197/125045063-44987580-e0a5-11eb-8ea2-3c4708e4616b.png)
<sub>* IP'i bir domain ile ilişkilendirmek için kullanabiliriz.</sub>

- Ingress'i oluşturmak için
```
kubectl apply -f k8s/azure_aks/ingress_frontend.yaml
```
<sub>* Blog yazısında _Azure DevOps_ üzerinden basitçe _kubectl_ komutlarını çalıştırıyorduk. Ama komut satırından da bütün _service, pod...vs._ tanımları çalıştırılabilir. Repository'deki k8s klasörü altındaki, __azure_aks__ klasörü altındaki *.yaml dosyalarını benzer şekilde çalıştırmak mümkün  </sub>


- Sertifika kontrolleri
```
kubectl get certificates
kubectl get certificaterequests.cert-manager.io 
kubectl describe certificate www-crt
kubectl delete certificate www-crt
```
