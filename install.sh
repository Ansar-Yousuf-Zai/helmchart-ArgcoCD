# Set Env Vars
export TLS_SEC=argocd-ingress-tls
export DNS_FQDN=argo.argocd123.com

kubectl create ns argocd

kubectl create secret tls argocd-ingress-tls \
    --namespace argocd \
    --key aks-ingress-tls.key \
    --cert aks-ingress-tls.crt

# Install argocd using previously created vars and the values.yaml file
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd -f values.yaml \
--namespace argocd --create-namespace \
--set server.ingress.hosts[0]=$DNS_FQDN,\
server.config.url="https://$DNS_FQDN",\
server.ingress.tls[0].hosts[0]=$DNS_FQDN,\
"server.ingress.tls[0].secretName=$TLS_SEC"




#helm repo add argo https://argoproj.github.io/argo-helm
#helm repo update
#helm upgrade --install argocd argo/argo-cd -f values.yaml \
#--namespace argocd --create-namespace \
#--set server.ingress.hosts[0]=$DNS_FQDN \ 
#--set server.config.url=https://$DNS_FQDN \
#--set "server.config.oidc\.config=$oidcvar" \
#--set "server.rbacConfig.policy\.csv=$policyvar" \
#--set "configs.secret.extra.oidc\.azure\.clientSecret=$ARGO_SECRET" \
#--set server.ingress.tls[0].hosts[0]=$DNS_FQDN \
#--set "server.ingress.tls[0].secretName=$tlssecret"