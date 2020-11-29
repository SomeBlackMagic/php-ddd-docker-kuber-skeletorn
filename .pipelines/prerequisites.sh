#!/usr/bin/env bash
try
(

    rancher_lock && rancher_login && helm_cluster_login
    rancher_namespace
    helm_init_namespace
    namespace_secret_additional_project_registry ${CI_PROJECT_NAME} ${CI_REGISTRY_USER} ${CI_JOB_TOKEN}

    ${KUBECTL} -n ${KUBE_NAMESPACE} create secret generic ${CI_PROJECT_NAME}-generic \
      --from-literal=APP_ENV="${APP_ENV}" \
      --from-literal=APP_DEBUG="${APP_DEBUG}" \
      --from-literal=APP_VERSION="${CI_COMMIT_REF_NAME}" \
      --from-literal=APP_SECRET="${APP_SECRET}" \
      \
      --from-literal=APP_SENTRY_DSN="${APP_SENTRY_DSN}" \
      \
      --from-literal=APP_REDIS_HOST="${APP_REDIS_HOST}" \
      --from-literal=APP_REDIS_PORT="${APP_REDIS_PORT}" \
      \
      --from-literal=APP_MYSQL_HOST="${APP_MYSQL_HOST}" \
      --from-literal=APP_MYSQL_PORT="${APP_MYSQL_PORT}" \
      --from-literal=APP_MYSQL_USER="${APP_MYSQL_USER}" \
      --from-literal=APP_MYSQL_PASS="${APP_MYSQL_PASS}" \
      --from-literal=APP_MYSQL_DB="${APP_MYSQL_DB}" \
      \
      --from-literal=APP_MAILER_URL="${APP_MAILER_URL}" \
      --from-literal=APP_MAILER_SENDER_EMAIL="${APP_MAILER_SENDER_EMAIL}" \
      --from-literal=APP_MAILER_SENDER_FROM_NAME="${APP_MAILER_SENDER_FROM_NAME}" \
      \
      --from-literal=APP_JWT_SECRET_KEY="${APP_JWT_SECRET_KEY}" \
      --from-literal=APP_JWT_PUBLIC_KEY="${APP_JWT_PUBLIC_KEY}" \
      --from-literal=APP_JWT_PASSPHRASE="${APP_JWT_PASSPHRASE}" \
      \
      --from-literal=APP_GOOGLE_CLIENT_ID="${APP_GOOGLE_CLIENT_ID}" \
      --from-literal=APP_GOOGLE_CLIENT_SECRET="${APP_GOOGLE_CLIENT_SECRET}" \
      \
      --from-literal=APP_GOOGLE_2FA_COMPANY="${APP_GOOGLE_2FA_COMPANY}" \
      --from-literal=APP_GOOGLE_2FA_CONTACT="${APP_GOOGLE_2FA_CONTACT}" \
      \
      --from-literal=APP_COINBASE_SECRET="${APP_COINBASE_SECRET}" \
      \
      -o yaml --dry-run | ${KUBECTL} -n ${KUBE_NAMESPACE} replace --force -f -

    helm_deploy_by_name_with_config redis stable/redis .helm/site-backend-redis/redis.yaml
    helm_deploy_by_name_with_config mysql stable/mysql .helm/site-backend-mysql/mysql.yaml

    namespace_secret_acme_cert ingress-cert ${KUBE_INGRESS_CERT_HOSTNAME}
)
# directly after closing the subshell you need to connect a group to the catch using ||
catch || {
   rancher_logout && rancher_unlock helm_cluster_logout
   exit $ex_code
}

rancher_logout && rancher_unlock && helm_cluster_logout
