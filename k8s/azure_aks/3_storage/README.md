## Persistent Volume - Azure Storage File Share

Bu örnekte bir Azure Storage'da yaratılmış bir File Share'i __Persistent Volume__ olarak kullanabiliyoruz.

Persistent Storage ile, pod'lardan bağımsız bir şekilde sabit bir depolama alanını oluşturup uygulamanın dosyalar üzerinde işlem yapması sağlanabilir.

- Azure Storage Account bilgilerini K8s'de bir secret içinde saklamak için
```
kubectl create secret generic azure-secret --from-literal=azurestorageaccountname={Azure Storage Adı} --from-literal=azurestorageaccountkey={Azure Storage Key}
```

- Persistent Volume oluşturmak için
```
kubectl apply -f k8s/azure_aks/3_storage/persistent_storage/persistent_volumes.yaml
```

- Deployment'a aşağıdaki gibi önceden oluşturduğumuz Volume'u ilişkilendirmek içim
```yaml
     ..
     ...
     ....
     spec:
      containers:
      - name: sampleapp-container
        .....
        ..
        volumeMounts:
        - mountPath: "/files"
          name: filevolume
      volumes:
        - name: filevolume
          persistentVolumeClaim:
            claimName: persistent-volume-claim
      ....
      ...
      ..
```

- Bu örnekte uygulama tarafından upload edilen dosyalar, pod'dan bağımsız bir şekilde, daha önceden yaratılmış bir tane __Azure Storage__'da tutulabilmekte. Pod'lar silinse bile dosyalar korunabilmekte.
![Screen Shot 2021-08-26 at 23 01 30](https://user-images.githubusercontent.com/4550197/131028394-1d99fa8c-f53f-44f3-a33b-6067226dfca6.png)
