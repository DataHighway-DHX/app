#!/usr/bin/env bash
#Place this script in project/android/app/

cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter clean

# accepting all licenses
yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

flutter channel stable
flutter doctor -v --android-licenses

echo "Installed flutter to `pwd`/flutter"

# build APK
flutter build apk --flavor prod

# if you need build bundle (AAB) in addition to your APK, uncomment line below and last line of this script.
flutter build appbundle --flavor play

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/prod/release/app-prod-release.apk $_

# copy the AAB where AppCenter will find it
# mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/release/app.aab $_
# choose a different release channel if you want - https://github.com/flutter/flutter/wiki/Flutter-build-release-channels
# stable - recommended for production
git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH
flutter channel stable
flutter doctor

# update node.js version and build main.js before flutter build
brew uninstall node@6
NODE_VERSION="12.16.0"
curl "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.pkg" > "$HOME/Downloads/node-installer.pkg"
sudo installer -store -pkg "$HOME/Downloads/node-installer.pkg" -target "/"
cd ./lib/js_service_kusama && yarn install && yarn run build && cd ../..
cd ./lib/js_service_acala && yarn install && yarn run build && cd ../..

touch .env
echo "MNENOMIC=${MNENOMIC}" > .env
echo "ETHEREUM_ADDRESS=${ETHEREUM_ADDRESS}" >> .env
echo "CONTRACT_ADDRESS_LOCKDROP_TESTNET=${CONTRACT_ADDRESS_LOCKDROP_TESTNET}" >> .env
echo "CONTRACT_ADDRESS_MXC_TESTNET=${CONTRACT_ADDRESS_MXC_TESTNET}" >> .env
echo "CONTRACT_ADDRESS_IOTA_PEGGED_TESTNET=${CONTRACT_ADDRESS_IOTA_PEGGED_TESTNET}" >> .env
echo "CONTRACT_ADDRESS_LOCKDROP_MAINNET=${CONTRACT_ADDRESS_LOCKDROP_MAINNET}" >> .env
echo "CONTRACT_ADDRESS_MXC_MAINNET=${CONTRACT_ADDRESS_MXC_MAINNET}" >> .env
echo "CONTRACT_ADDRESS_IOTA_PEGGED_MAINNET=${CONTRACT_ADDRESS_IOTA_PEGGED_MAINNET}" >> .env
echo "INFURA_API_PROJECT_ID=${INFURA_API_PROJECT_ID}" >> .env
echo "ENVIRONMENT=${ENVIRONMENT}" >> .env

flutter build apk --release --flavor prod
flutter build appbundle --release --flavor prod

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/prod/release/app-prod-release.apk $_
# copy the AAB where AppCenter will find it
mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/prodRelease/app-prod-release.aab $_