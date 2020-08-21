#!/usr/bin/env bash
#Place this script in project/android/app/

cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter clean

# accepting all licenses
yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

flutter channel stable
flutter doctor -v --android-licenses

echo "Installed flutter to `pwd`/flutter"


NODE_VERSION="12.16.0"
curl "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.pkg" > "$HOME/Downloads/node-installer.pkg"
sudo installer -store -pkg "$HOME/Downloads/node-installer.pkg" -target "/"
cd ./lib/polkadot_js_service && yarn install && yarn run build && cd ../..

touch assets/.env
echo "MNENOMIC=${MNENOMIC}" > assets/.env
echo "ETHEREUM_ADDRESS=${ETHEREUM_ADDRESS}" >> assets/.env
echo "CONTRACT_ADDRESS_LOCKDROP_TESTNET=${CONTRACT_ADDRESS_LOCKDROP_TESTNET}" >> assets/.env
echo "CONTRACT_ADDRESS_MXC_TESTNET=${CONTRACT_ADDRESS_MXC_TESTNET}" >> assets/.env
echo "CONTRACT_ADDRESS_IOTA_PEGGED_TESTNET=${CONTRACT_ADDRESS_IOTA_PEGGED_TESTNET}" >> assets/.env
echo "CONTRACT_ADDRESS_LOCKDROP_MAINNET=${CONTRACT_ADDRESS_LOCKDROP_MAINNET}" >> assets/.env
echo "CONTRACT_ADDRESS_MXC_MAINNET=${CONTRACT_ADDRESS_MXC_MAINNET}" >> assets/.env
echo "CONTRACT_ADDRESS_IOTA_PEGGED_MAINNET=${CONTRACT_ADDRESS_IOTA_PEGGED_MAINNET}" >> assets/.env
echo "INFURA_API_PROJECT_ID=${INFURA_API_PROJECT_ID}" >> assets/.env
echo "ENVIRONMENT=${ENVIRONMENT}" >> assets/.env

# build APK
flutter build apk --flavor prod

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
flutter build appbundle --flavor play

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/prod/release/app-prod-release.apk $_

# copy the AAB where AppCenter will find it
mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/playRelease/app-play-release.aab $_
