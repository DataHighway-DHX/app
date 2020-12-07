#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter clean
flutter channel stable
flutter doctor -v
echo "Installed flutter to `pwd`/flutter"

# update node.js version and build main.js before flutter build
NODE_VERSION="12.16.0"
curl "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.pkg" > "$HOME/Downloads/node-installer.pkg"
sudo installer -store -pkg "$HOME/Downloads/node-installer.pkg" -target "/"
cd ./lib/js_service_kusama && yarn install && yarn run build && cd ../..
cd ./lib/js_service_acala && yarn install && yarn run build && cd ../..
cd ./lib/js_service_datahighway && yarn install && yarn run build && cd ../..

touch assets/.env
echo "MNENOMIC=${MNENOMIC}" > assets/.env
echo "INFURA_API_PROJECT_ID=${INFURA_API_PROJECT_ID}" >> assets/.env
echo "ENVIRONMENT=${ENVIRONMENT}" >> assets/.env
echo "DEPLOYERS_LIST=${DEPLOYERS_LIST}" >> assets/.env
echo "DEMO_USERNAME=${DEMO_USERNAME}" >> assets/.env
echo "DEMO_PASSWORD=${DEMO_PASSWORD}" >> assets/.env

flutter build ios --release --no-codesign
