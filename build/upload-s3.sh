#
#  Copyright 2018 Draios Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#!/bin/bash

set -x

VERSION=$1
BUILD_ID=$2
BRANCH_NAME=$3

FILE_NAME_PREFIX="grafana-sysdig-datasource"
BUILD_FILE_NAME="${FILE_NAME_PREFIX}-v${VERSION}.${BUILD_ID}"
LATEST_FILE_NAME="${FILE_NAME_PREFIX}-v${VERSION}"
S3_BUCKET="s3://download.draios.com"
DIST_PATH="dist"

if [[ "$BRANCH_NAME" == 'master' ]]; then
    S3_DEST="stable/grafana-sysdig-datasource"
elif [[ "$BRANCH_NAME" == 'dev' ]]; then
    S3_DEST="dev/grafana-sysdig-datasource"
else
    S3_DEST="dev/grafana-sysdig-datasource/${BRANCH_NAME}"
fi

echo "Cleaning up artifacts...."
cp -R ${DIST_PATH} sysdig
rm -rf sysdig/test

echo "Deploying zip file...."
zip -ry ${BUILD_FILE_NAME}.zip sysdig
aws s3 cp ${BUILD_FILE_NAME}.zip ${S3_BUCKET}/${S3_DEST}/${BUILD_FILE_NAME}.zip --acl public-read
aws s3 cp ${BUILD_FILE_NAME}.zip ${S3_BUCKET}/${S3_DEST}/${LATEST_FILE_NAME}.zip --acl public-read

echo "Deploying tgz file...."
tar zcvf ${BUILD_FILE_NAME}.tgz sysdig
aws s3 cp ${BUILD_FILE_NAME}.tgz ${S3_BUCKET}/${S3_DEST}/${BUILD_FILE_NAME}.tgz --acl public-read
aws s3 cp ${BUILD_FILE_NAME}.tgz ${S3_BUCKET}/${S3_DEST}/${LATEST_FILE_NAME}.tgz --acl public-read
