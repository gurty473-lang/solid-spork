#!/usr/bin/env bash
# Linux/macOS build helper. Needs JDK 21+. Downloads Gradle 9.2.1 if none is found.
set -e
cd "$(dirname "$0")"
GRADLE_VERSION=9.2.1
DIST=".gradle-dist/gradle-$GRADLE_VERSION"

if [ -x ./gradlew ] && [ -f gradle/wrapper/gradle-wrapper.jar ]; then
  G=./gradlew
elif [ -x "$DIST/bin/gradle" ]; then
  G="$DIST/bin/gradle"
elif command -v gradle >/dev/null 2>&1; then
  G=gradle
else
  mkdir -p .gradle-dist
  curl -fL "https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip" -o .gradle-dist/g.zip
  unzip -q .gradle-dist/g.zip -d .gradle-dist && rm .gradle-dist/g.zip
  G="$DIST/bin/gradle"
  "$G" wrapper --gradle-version "$GRADLE_VERSION" --no-daemon
fi
"$G" build --no-daemon
echo "Jar(s) in build/libs:"; ls build/libs
