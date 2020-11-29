#!/usr/bin/env bash
registry_login

if [[ ! "$CI_COMMIT_REF_NAME" =~ ^v.* ]]; then
  HELM_ENV="dev"
  APP_ENV="dev"
  KUBE_NAMESPACE=$(kubernetes_namespace_sanitize ${KUBE_NAMESPACE_PREFIX}-${CI_COMMIT_REF_NAME} 25)
  KUBE_INGRESS_HOSTNAME=${KUBE_NAMESPACE}.${KUBE_INGRESS_HOSTNAME_SUFFIX}
  KUBE_INGRESS_CERT_HOSTNAME=*.${KUBE_INGRESS_HOSTNAME_SUFFIX}
fi

if [[ "$DEV_ENV" = "preprod" ]]; then
  APP_ENV="prod"
fi

if [[ "$CI_COMMIT_REF_NAME" =~ ^v.* ]]; then
  HELM_ENV="prod"
  APP_ENV="prod"
  KUBE_NAMESPACE=$(kubernetes_namespace_sanitize ${KUBE_NAMESPACE_PREFIX}-${PROD_ENV} 25)
  KUBE_INGRESS_HOSTNAME=${KUBE_INGRESS_HOSTNAME}
  KUBE_INGRESS_CERT_HOSTNAME=${KUBE_INGRESS_HOSTNAME}
fi

echo "HELM_ENV - $HELM_ENV"
echo "KUBE_NAMESPACE - $KUBE_NAMESPACE"
echo "KUBE_INGRESS_HOSTNAME - $KUBE_INGRESS_HOSTNAME"
echo "KUBE_INGRESS_CERT_HOSTNAME - $KUBE_INGRESS_CERT_HOSTNAME"
