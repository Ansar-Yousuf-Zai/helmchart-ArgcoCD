openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out argo-ingress-tls.crt \
    -keyout argo-ingress-tls.key \
    -subj "/CN=argo.argocd123.com/O=aks-ingress2-tls"