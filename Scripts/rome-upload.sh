#!/bin/sh
PLATFORM=${1:-iOS,tvOS}

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/setup_env.sh"

lockfile_waithold "rome-upload"

SWIFT_VERSION=`swift --version | head -1 | sed 's/.*\((.*)\).*/\1/' | tr -d "()" | tr " " "-"`
echo "Swift version: $SWIFT_VERSION"

echo "Uploading $PLATFORM ..."

MISSING=`rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}'`
echo "Missing $MISSING"
echo $MISSING | awk '{print $1}' | carthage update --platform $PLATFORM --cache-builds && rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}' | xargs rome upload --platform $PLATFORM --cache-prefix "$SWIFT_VERSION"

cd PVSupport

MISSING=`rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}'`
echo "Missing $MISSING"
echo $MISSING | awk '{print $1}' | carthage update --platform $PLATFORM --cache-builds && rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}' | xargs rome upload --platform $PLATFORM --cache-prefix "$SWIFT_VERSION"

cd ../PVLibrary

MISSING=`rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}'`
echo "Missing $MISSING"
echo $MISSING | awk '{print $1}' | carthage update --platform $PLATFORM --cache-builds && rome list --missing --platform $PLATFORM --cache-prefix "$SWIFT_VERSION" | awk '{print $1}' | xargs rome upload --platform $PLATFORM --cache-prefix "$SWIFT_VERSION"

echo "Done."

lockfile_release "rome-upload"
