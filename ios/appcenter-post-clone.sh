#!/usr/bin/env bash
#Place this script in project/ios/

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter clean
flutter channel stable
flutter doctor -v

echo "Installed flutter to `pwd`/flutter"

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

flutter build ios --release --no-codesign