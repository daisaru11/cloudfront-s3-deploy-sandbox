#!/usr/bin/env bash

set -eu

DIR=$(cd $(dirname $BASH_SOURCE); pwd)
ROOT_DIR="${DIR}/"
cd ${ROOT_DIR}

# build
cd webapp
yarn build
sed -i '' 's/##date##/'$(date +'%Y%m%d%H%M')'/' dist/index.html
cd ${ROOT_DIR}

AWS="aws --profile=private_playground"
DISTRIBUTION_ID=$(cd terraform && terraform output distribution_id)

$AWS s3 sync ./webapp/dist s3://webapp.daisaru11/ --delete
$AWS cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths '/*'
