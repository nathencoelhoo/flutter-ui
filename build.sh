#!/bin/bash
set -e
git config --global --add safe.directory '*'
cp lib/main.dart /tmp/main.dart
cp pubspec.yaml /tmp/pubspec.yaml
git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter
flutter/bin/flutter config --enable-web
flutter/bin/flutter create . --platforms web --project-name festival_guide
cp /tmp/main.dart lib/main.dart
cp /tmp/pubspec.yaml pubspec.yaml
flutter/bin/flutter pub get
flutter/bin/flutter build web --release
