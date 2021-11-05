## Azure Key Vault Provider


- AKS Preview eklentisinin güncellenmesi ve gerekli bazı özelliklerin aktivasyonu
```
az extension update --name aks-preview
az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
```

- AKS Cluster'ın User Managed Identity'sinin Client ID'si(SecretProviderClass için gerekli)
```
az aks show -g k8s-demo-resources -n k8s-cluster-01 --query identityProfile.kubeletidentity.clientId -o tsv
```

- KeyVault'a gerekli Access Policy tanımını yapmak için(terraform tarafında da yapılabilir)
```
az keyvault set-policy -n aksk8skeyvault --secret-permissions get --spn {Cluster User Managed Identity Client ID}
```

- KV Secret'larının pod için kontrolü
```
kubectl exec {Pod adı} -- ls /mnt/secrets-store/
kubectl exec {Pod adı}  -- cat /mnt/secrets-store/SomeSecret
```