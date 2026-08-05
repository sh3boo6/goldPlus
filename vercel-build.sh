#!/bin/sh
# Install Flutter if not available
if ! command -v flutter > /dev/null 2>&1; then
  echo "Installing Flutter..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git
  export PATH="$PATH:$(pwd)/flutter/bin"
fi

# Build the Flutter web app
flutter pub get
flutter build web
