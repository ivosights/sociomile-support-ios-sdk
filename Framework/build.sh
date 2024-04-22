#!/bin/sh

#  build.sh
#  SociomileSupportSDK
#
#  Created by Meynisa on 19/04/24.
#  Copyright © 2024 CocoaPods. All rights reserved.

# # Merge Script
# # 1
# # Set bash script to exit immediately if any commands fail.
set -e
# 2
# Setup some constants for use later on.
BUILD_DIR=$1
SCHEME=$2
CONFIGURATION=$3
WORKSPACE=$1/SociomileSupportSDK.xcworkspace
FRAMEWORK_PATH=/Users/aprikot/Projects/SCM-SDK/sociomile-ios-sdk/SociomileSupportSDK/Framework
FRAMEWORK_NAME=$2.framework
DERIVED_DATA_PATH=$BUILD_DIR/DerivedData
IPHONEOS="generic/platform=iOS"
IPHONESIMULATOR="platform=iOS Simulator,name=iPhone 13"
# # 3
# # If remnants from a previous build exist, delete them.
if [ -d "${FRAMEWORK_PATH}/${FRAMEWORK_NAME}" ]; then
    echo "There was a previous build and it will be deleted"
    rm -rf "${FRAMEWORK_PATH}/${FRAMEWORK_NAME}"
fi
if [ -d "${DERIVED_DATA_PATH}" ]; then
    echo "There was a previous delivered data and it will be deleted"
    rm -rf "${DERIVED_DATA_PATH}"
fi
# # 4
# # Perform a pod install to be sure that everything is ok and build # # the framework for device and for simulator.
cd $BUILD_DIR
pod install
if [ $CONFIGURATION = "Release" ]; then
    xcodebuild -quiet -showBuildTimingSummary -workspace $WORKSPACE -configuration $CONFIGURATION -scheme $SCHEME -derivedDataPath $DERIVED_DATA_PATH -destination "${IPHONEOS}"
else
    xcodebuild -quiet -showBuildTimingSummary -workspace $WORKSPACE -configuration $CONFIGURATION -scheme $SCHEME -derivedDataPath $DERIVED_DATA_PATH -destination "${IPHONEOS}" -destination "${IPHONESIMULATOR}"
fi
# # 5
# # Copy the device version of framework to Framework Path.
cp -r "${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphoneos/${SCHEME}/${FRAMEWORK_NAME}" "${FRAMEWORK_PATH}/${FRAMEWORK_NAME}"
# # 6
# # If the configuration is Debug replace the framework executable
# # within the framework with a new version created by merging the
# # device and simulator frameworks’ executables with lipo, and
# # merge the architecture between simulator and real device.
if [ $CONFIGURATION = "Debug" ]; then
    lipo -create -output "${FRAMEWORK_PATH}/${FRAMEWORK_NAME}/${SCHEME}" "${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphoneos/${SCHEME}/${FRAMEWORK_NAME}/${SCHEME}" "${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphonesimulator/${SCHEME}/${FRAMEWORK_NAME}/${SCHEME}"
    ditto -V "${DERIVED_DATA_PATH}/Build/Products/${CONFIGURATION}-iphonesimulator/${SCHEME}/${FRAMEWORK_NAME}/Modules" "${FRAMEWORK_PATH}/${FRAMEWORK_NAME}/Modules"
fi
# # 7
# Delete the most recent Delivered Data Path.
if [ -d "${DERIVED_DATA_PATH}" ]; then
rm -rf "${DERIVED_DATA_PATH}"
fi
# # 8
# Open folder
echo "Build Success"
open $FRAMEWORK_PATH
