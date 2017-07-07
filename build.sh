#!/bin/bash

# ------------------------------------------------------------------------------
# Builds SDL2 static libraries and frameworks for iOS and tvOS
# ------------------------------------------------------------------------------

task() {
  printf "\n\033[1;34m==>\033[1;39m $1\033[0m\n\n"
}

# Use xcpretty for nicer output: gem install xcpretty
if xcpretty -v &>/dev/null; then
  XCPRETTY=xcpretty
else
  task "xcpretty not found!"
  echo -e "  Run \`gem install xcpretty\` for nicer xcodebuild output."
  XCPRETTY=cat
fi

set -e

IOS_DIR=`pwd`/ios
TVOS_DIR=`pwd`/tvos

mkdir -p $IOS_DIR/include/SDL2
mkdir -p $IOS_DIR/lib
mkdir -p $TVOS_DIR/include/SDL2
mkdir -p $TVOS_DIR/lib

mkdir -p tmp
cd tmp

# Set SDL2 lib URLs

sdl_url="https://hg.libsdl.org/SDL/archive/tip.tar.gz"
image_url="https://hg.libsdl.org/SDL_image/archive/tip.tar.gz"
mixer_url="https://hg.libsdl.org/SDL_mixer/archive/tip.tar.gz"
ttf_url="https://hg.libsdl.org/SDL_ttf/archive/tip.tar.gz"

# Download SDL2 libs

if [ ! -f SDL2.tar.gz ]; then
  task "Downloading SDL2..."
  curl $sdl_url -o SDL2.tar.gz
fi

if [ ! -f SDL2_image.tar.gz ]; then
  task "Downloading SDL2_image..."
  curl $image_url -o SDL2_image.tar.gz
fi

if [ ! -f SDL2_mixer.tar.gz ]; then
  task "Downloading SDL2_mixer..."
  curl $mixer_url -o SDL2_mixer.tar.gz
fi

if [ ! -f SDL2_ttf.tar.gz ]; then
  task "Downloading SDL2_ttf..."
  curl $ttf_url -o SDL2_ttf.tar.gz
fi

# Extract and rename directories

task "Extracting SDL directories..."

if [ ! -d SDL2 ]; then
  tar -xzf SDL2.tar.gz
  mv SDL-* SDL2
fi

if [ ! -d SDL2_image ]; then
  tar -xzf SDL2_image.tar.gz
  mv SDL_image-* SDL2_image
fi

if [ ! -d SDL2_mixer ]; then
  tar -xzf SDL2_mixer.tar.gz
  mv SDL_mixer-* SDL2_mixer
fi

if [ ! -d SDL2_ttf ]; then
  tar -xzf SDL2_ttf.tar.gz
  mv SDL_ttf-* SDL2_ttf
fi

# Builds a static library
build() {
  target=$1
  fname=$2
  env1=$3
  env2=$4

  # Ignore empty environment variable args, replace with dummy var
  if [[ $3 == '' ]]; then env1="A="; fi
  if [[ $4 == '' ]]; then env2="A="; fi

  task "Building $fname for iPhone..."
  xcodebuild -target "$target" -configuration Release -sdk iphoneos         "$env1" "$env2" | $XCPRETTY

  task "Building $fname for iPhone Simulator..."
  xcodebuild -target "$target" -configuration Release -sdk iphonesimulator  "$env1" "$env2" | $XCPRETTY

  task "Building $fname for Apple TV..."
  xcodebuild -target "$target" -configuration Release -sdk appletvos        "$env1" "$env2" | $XCPRETTY

  task "Building $fname for Apple TV Simulator..."
  xcodebuild -target "$target" -configuration Release -sdk appletvsimulator "$env1" "$env2" | $XCPRETTY

  task "Building $fname universal libs..."

  mkdir -p build/Release-ios-universal
  lipo build/Release-iphoneos/$fname.a build/Release-iphonesimulator/$fname.a -create -output build/Release-ios-universal/$fname.a

  mkdir -p build/Release-tvos-universal
  lipo build/Release-appletvos/$fname.a build/Release-appletvsimulator/$fname.a -create -output build/Release-tvos-universal/$fname.a
}

# Build SDL2 ###################################################################

task "Building SDL2..."

cd SDL2/Xcode-iOS/SDL

build libSDL libSDL2

cp -r ../../include/*.h $IOS_DIR/include/SDL2
cp -r ../../include/*.h $TVOS_DIR/include/SDL2

cp build/Release-ios-universal/libSDL2.a $IOS_DIR/lib
cp build/Release-tvos-universal/libSDL2.a $TVOS_DIR/lib

cd ../../..

# Build SDL2_image #############################################################

task "Building SDL2_image..."

cd SDL2_image/Xcode-iOS

build libSDL_image libSDL2_image "HEADER_SEARCH_PATHS=../../SDL2/include"

cp ../SDL_image.h $IOS_DIR/include/SDL2
cp ../SDL_image.h $TVOS_DIR/include/SDL2

cp build/Release-ios-universal/libSDL2_image.a $IOS_DIR/lib
cp build/Release-tvos-universal/libSDL2_image.a $TVOS_DIR/lib

cd ../..

# Build SDL2_mixer #############################################################

task "Building SDL2_mixer..."

cd SDL2_mixer/Xcode-iOS

build "Static Library" libSDL2_mixer "HEADER_SEARCH_PATHS=../../SDL2/include ../external/libmodplug-0.8.8.4/src ../external/libmodplug-0.8.8.4/src/libmodplug ../external/libvorbisidec-1.2.1 ../external/libogg-1.3.1/include" "GCC_PREPROCESSOR_DEFINITIONS=WAV_MUSIC MID_MUSIC OGG_MUSIC OGG_USE_TREMOR OGG_HEADER=<ivorbisfile.h> HAVE_STDINT_H HAVE_SETENV HAVE_SINF"

cp ../SDL_mixer.h $IOS_DIR/include/SDL2
cp ../SDL_mixer.h $TVOS_DIR/include/SDL2

cp build/Release-ios-universal/libSDL2_mixer.a $IOS_DIR/lib
cp build/Release-tvos-universal/libSDL2_mixer.a $TVOS_DIR/lib

cd ../..

# Build SDL2_ttf ###############################################################

task "Building SDL2_ttf..."

cd SDL2_ttf/Xcode-iOS

build "Static Library" libSDL2_ttf "HEADER_SEARCH_PATHS=../../SDL2/include ../external/freetype-2.4.12/include"

cp ../SDL_ttf.h $IOS_DIR/include/SDL2
cp ../SDL_ttf.h $TVOS_DIR/include/SDL2

cp build/Release-ios-universal/libSDL2_ttf.a $IOS_DIR/lib
cp build/Release-tvos-universal/libSDL2_ttf.a $TVOS_DIR/lib

cd ../..

# Create SDL2 Framework ########################################################

build_framework() {

  cd lib
  libtool -static libSDL2.a libSDL2_image.a libSDL2_mixer.a libSDL2_ttf.a -o SDL2
  cd ..

  mkdir -p SDL2.framework/Headers
  cp -r include/SDL2/*.h SDL2.framework/Headers
  mv lib/SDL2 SDL2.framework

  cat > SDL2.framework/Info.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>SDL2</string>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundlePackageType</key>
  <string>FMWK</string>
  <key>CFBundleIdentifier</key>
  <string>org.libsdl.SDL2</string>
  <key>CFBundleExecutable</key>
  <string>SDL2</string>
  <key>CFBundleVersion</key>
  <string>1</string>
</dict>
</plist>
EOF
}

task "Building SDL2 framework for iOS and tvOS..."

cd ../ios
build_framework
cd ../tvos
build_framework

task "Done!"
