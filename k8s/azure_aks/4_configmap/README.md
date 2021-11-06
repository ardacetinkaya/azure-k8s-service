## Configmap

Pod'lardaki konfigürasyon amaçlı değerleri **configmap** oluşturarak, tüm pod'larda geçerli olacak şekilde tanımlamak mümkün

- Secret değerleri için Base64 değerler için
```
echo -n "someusername" | base64
echo -n "somecomplexpassword" | base64
```