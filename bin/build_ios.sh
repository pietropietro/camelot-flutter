#!/bin/sh

if [[ $# -ne 2 ]] ; then
    echo "[USAGE] $0 version_name version_number"
    echo "E.g.: $0 1.0.3 3"
    exit -1
fi

source ./bin/util.sh

echo_colored "Building iOS" $GREEN

VERSION_NAME=$1
VERSION_NUMBER=$2

cd rousseau_vote
git-crypt unlock
cp ios/Runner/GoogleService-Info.plist.release ios/Runner/GoogleService-Info.plist
flutter build ios --build-name $VERSION_NAME --build-number $VERSION_NUMBER

# Cleanup
git checkout ios/Runner/GoogleService-Info.plist
cd ..
