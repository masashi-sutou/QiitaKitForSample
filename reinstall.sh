#!/bin/sh -x

rm Podfile.lock
rm Gemfile.lock
rm Cartfile.resolved
rm -rf .bundle
rm -rf vendor
rm -rf Pods
rm -rf QiitaKitForSample.xcworkspace
rm -rf ~/Library/Developer/Xcode/DerivedData/QiitaKitForSample*

# bundle install --path vendor/bundle
# bundle exec pod install
# pod install
carthage update --no-use-binaries --platform iOS
