#!/usr/bin/env bash

set -eux
set -o pipefail
#---------------GLOBAL vars -------------

export PROD_ENV=staging
export DEV_ENV=dev
export CI_PROJECT_NAME=application-backend

#---------------DEV vars -------------
export ADMIN_EMAIL=root@localhost
export KUBE_NAMESPACE_PREFIX=application-site
export KUBE_INGRESS_PATH=/api
#---------------stage/prod vars -------------

source .pipelines/.env
if [ -f ".pipelines/.env.local" ]; then
    source .pipelines/.env.local
fi


#import functions
. .gitlab-ci-functions/docker.sh
. .gitlab-ci-functions/kubernetes.sh
. .gitlab-ci-functions/mysql.sh
. .gitlab-ci-functions/misc.sh
. .gitlab-ci-functions/trycatch.sh


. .pipelines/transform_from_jenkins.sh
. .pipelines/before_step.sh

. .pipelines/build_images.sh
. .pipelines/app_image.sh
. .pipelines/app_test.sh
. .pipelines/prerequisites.sh
. .pipelines/app_deploy.sh
