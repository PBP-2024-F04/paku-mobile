#!/usr/bin/env bash
# Place this script in project/android/app/

cd ..

# fail if any command fails
set -e
# debug log
set -x

cd ..
git clone -b beta https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor

echo "Installed flutter to `pwd`/flutter"

# export keystore for release
echo "$KEY_JKS" | base64 --decode > release-keystore.jks

# build APK
# if you get "Execution failed for task ':app:lintVitalRelease'." error, uncomment next two lines
# flutter build apk --debug --dart-define=API_URL=https://muhammad-vito31-paku.pbp.cs.ui.ac.id
# flutter build apk --profile --dart-define=API_URL=https://muhammad-vito31-paku.pbp.cs.ui.ac.id
flutter build apk --release --dart-define=API_URL=https://muhammad-vito31-paku.pbp.cs.ui.ac.id

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_
