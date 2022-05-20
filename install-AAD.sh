# Set Env Vars
export TLS_SEC=argocd-ingress-tls
export DNS_FQDN=argo.argocd123.com

export AZURE_TENANT=8f12f317-2734-454e-8e5c-3941f8946c51
export ARGO_CLIENTID=a75bb1a5-4445-49b5-8474-d2b28fa3e3ce
export ARGO_ADMINGROUP=b4b3d541-7e6e-41f9-9c87-3d58ae31db78
export ARGO_READGROUP=76f5a632-ab4b-4cc0-94b2-984568f11484
export ARGO_SECRET=

# Setting required values for ArgoCD Azure AD Authentication
export OIDC_VAR="name: Azure AD
issuer: https://login.microsoftonline.com/$AZURE_TENANT/v2.0
clientID: $ARGO_CLIENTID
clientSecret: \$oidc.azure.clientSecret
requestedIDTokenClaims:
    groups:
        essential: true
requestedScopes:
    - openid
    - profile
    - email"

# Setting ArgoCD RBAC policy referring to Azure AD groupIds
export policyvar="g\, $ARGO_ADMINGROUP\, role:admin
g\, $ARGO_READGROUP\, role:readonly"


#create ArgoCD namespace
kubectl create ns argocd

#create secret for the certificate
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
"server.ingress.tls[0].secretName=$TLS_SEC",\
"server.config.oidc\.config=$OIDC_VAR",\
"server.rbacConfig.policy\.csv=$policyvar",\
"configs.secret.extra.oidc\.azure\.clientSecret=$ARGO_SECRET"