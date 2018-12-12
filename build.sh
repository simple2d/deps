#!/bin/bash

# Library URLs

sdl_src="https://www.libsdl.org/release/SDL2-2.0.9.tar.gz"
sdl_vc="https://www.libsdl.org/release/SDL2-devel-2.0.9-VC.zip"
sdl_mingw="https://www.libsdl.org/release/SDL2-devel-2.0.9-mingw.tar.gz"

image_src="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.4.tar.gz"
image_vc="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.4-VC.zip"
image_mingw="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.4-mingw.tar.gz"

mixer_src="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
mixer_vc="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.4-VC.zip"
mixer_mingw="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.4-mingw.tar.gz"

ttf_src="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
ttf_vc="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-VC.zip"
ttf_mingw="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.14-mingw.tar.gz"

glew_src="https://github.com/nigels-com/glew/archive/glew-2.1.0.zip"
glew_release="https://github.com/nigels-com/glew/releases/download/glew-2.1.0/glew-2.1.0-win32.zip"

# Directories

vc_sdl_include_dir=`pwd`/vc/SDL2/include/SDL2
vc_sdl_lib_dir=`pwd`/vc/SDL2/lib
vc_glew_include_dir=`pwd`/vc/glew/include
vc_glew_lib_dir=`pwd`/vc/glew/lib

mingw_bin_dir=`pwd`/mingw/bin
mingw_include_dir=`pwd`/mingw/include
mingw_sdl_include_dir=$mingw_include_dir/SDL2
mingw_lib_dir=`pwd`/mingw/lib

ios_dir=`pwd`/ios
tvos_dir=`pwd`/tvos

# Helpers

task() {
  printf "\033[1;34m==>\033[1;39m $1\033[0m\n"
}

set -e

# Make and enter temporary directory for libs

mkdir -p tmp
tmp_dir=`pwd`/tmp
cd $tmp_dir

# Download libs ################################################################

download() {
  # $1 Name; $2 URL; $3 Filename
  if [ ! -f $3 ]; then
    task "Downloading $1..."
    curl -L $2 -o $3
  else
    task "$1 already downloaded"
  fi
}

download "SDL2 source" $sdl_src   "SDL2.tar.gz"
download "SDL2 VC"     $sdl_vc    "SDL2-vc.zip"
download "SDL2 MinGW"  $sdl_mingw "SDL2-mingw.tar.gz"

download "SDL2_image source" $image_src   "SDL2_image.tar.gz"
download "SDL2_image VC"     $image_vc    "SDL2_image-vc.zip"
download "SDL2_image MinGW"  $image_mingw "SDL2_image-mingw.tar.gz"

download "SDL2_mixer source" $mixer_src   "SDL2_mixer.tar.gz"
download "SDL2_mixer VC"     $mixer_vc    "SDL2_mixer-vc.zip"
download "SDL2_mixer MinGW"  $mixer_mingw "SDL2_mixer-mingw.tar.gz"

download "SDL2_ttf source" $ttf_src   "SDL2_ttf.tar.gz"
download "SDL2_ttf VC"     $ttf_vc    "SDL2_ttf-vc.zip"
download "SDL2_ttf MinGW"  $ttf_mingw "SDL2_ttf-mingw.tar.gz"

download "GLEW source"  $glew_src     "glew.zip"
download "GLEW release" $glew_release "glew-release.zip"

# Extract and rename directories ###############################################

extract() {
  # $1 File to extract; $2 Rename to
  if [ ! -d $3 ]; then
    task "Extracting $1..."
    if [[ $1 == *.tar.gz ]]; then
      tar -xzf $1
    else
      unzip -q $1
    fi
    mv $2 $3
  else
    task "$1 already extracted"
  fi
}

extract "SDL2.tar.gz"       "SDL2-2.*" "SDL"
extract "SDL2-vc.zip"       "SDL2-2.*" "SDL-vc"
extract "SDL2-mingw.tar.gz" "SDL2-2.*" "SDL-mingw"

extract "SDL2_image.tar.gz"       "SDL2_image-2.*" "SDL_image"
extract "SDL2_image-vc.zip"       "SDL2_image-2.*" "SDL_image-vc"
extract "SDL2_image-mingw.tar.gz" "SDL2_image-2.*" "SDL_image-mingw"

extract "SDL2_mixer.tar.gz"       "SDL2_mixer-2.*" "SDL_mixer"
extract "SDL2_mixer-vc.zip"       "SDL2_mixer-2.*" "SDL_mixer-vc"
extract "SDL2_mixer-mingw.tar.gz" "SDL2_mixer-2.*" "SDL_mixer-mingw"

extract "SDL2_ttf.tar.gz"       "SDL2_ttf-2.*" "SDL_ttf"
extract "SDL2_ttf-vc.zip"       "SDL2_ttf-2.*" "SDL_ttf-vc"
extract "SDL2_ttf-mingw.tar.gz" "SDL2_ttf-2.*" "SDL_ttf-mingw"

extract "glew.zip"         "glew-glew*" "glew"
extract "glew-release.zip" "glew-2.*"   "glew-release"

# VC Libs ######################################################################

task "Making VC libs..."

mkdir -p $vc_sdl_include_dir
mkdir -p $vc_sdl_lib_dir
mkdir -p $vc_glew_include_dir
mkdir -p $vc_glew_lib_dir

copy_sdl_vc() {
  # $1 lib
  cp $1/include/*.h $vc_sdl_include_dir
  cp $1/lib/x64/*.{dll,lib} $vc_sdl_lib_dir
}

copy_sdl_vc "SDL-vc"
copy_sdl_vc "SDL_image-vc"
copy_sdl_vc "SDL_mixer-vc"
copy_sdl_vc "SDL_ttf-vc"

# Use SDL_mixer's version of zlib
cp SDL_image-vc/lib/x64/zlib1.dll $vc_sdl_lib_dir

cp glew-release/include/GL/glew.h $vc_glew_include_dir
cp glew-release/bin/Release/x64/glew32.dll \
   glew-release/lib/Release/x64/glew32.lib $vc_glew_lib_dir

# MinGW libs ###################################################################

task "Making MinGW libs..."

mkdir -p $mingw_bin_dir
mkdir -p $mingw_sdl_include_dir
mkdir -p $mingw_lib_dir

copy_sdl_mingw() {
  # $1 lib
  cp $1/x86_64-w64-mingw32/bin/*.dll $mingw_bin_dir
  cp $1/x86_64-w64-mingw32/include/SDL2/*.h $mingw_sdl_include_dir
  cp $1/x86_64-w64-mingw32/lib/*.a $mingw_lib_dir
}

copy_sdl_mingw "SDL-mingw"
copy_sdl_mingw "SDL_image-mingw"
copy_sdl_mingw "SDL_mixer-mingw"
copy_sdl_mingw "SDL_ttf-mingw"

cp glew-release/include/GL/glew.h $mingw_include_dir
cp ../glew-mingw/glew32.dll $mingw_bin_dir
cp ../glew-mingw/libglew32.a ../glew-mingw/libglew32.dll.a $mingw_lib_dir

# iOS and tvOS frameworks ######################################################

mkdir -p $ios_dir/include/SDL2
mkdir -p $ios_dir/lib
mkdir -p $tvos_dir/include/SDL2
mkdir -p $tvos_dir/lib

# Use xcpretty for nicer output: gem install xcpretty
if xcpretty -v &>/dev/null; then
  XCPRETTY=xcpretty
else
  task "xcpretty not found!"
  echo -e "  Run \`gem install xcpretty\` for nicer xcodebuild output."
  XCPRETTY=cat
fi

build_ios_tvos_lib() {
  target=$1
  fname=$2
  env1=$3
  env2=$4

  # Ignore empty environment variable args, replace with dummy var
  if [[ $env1 == '' ]]; then env1="A="; fi
  if [[ $env2 == '' ]]; then env2="A="; fi

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

# Build SDL2

task "Building SDL2 iOS and tvOS static libs..."

cd SDL/Xcode-iOS/SDL

build_ios_tvos_lib libSDL-iOS libSDL2

cp -R ../../include/*.h $ios_dir/include/SDL2
cp -R ../../include/*.h $tvos_dir/include/SDL2

cp build/Release-ios-universal/libSDL2.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_image

task "Building SDL2_image iOS and tvOS static libs..."

cd SDL_image/Xcode-iOS

build_ios_tvos_lib libSDL_image-iOS libSDL2_image

cp ../SDL_image.h $ios_dir/include/SDL2
cp ../SDL_image.h $tvos_dir/include/SDL2

cp build/Release-ios-universal/libSDL2_image.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_image.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_mixer

task "Building SDL2_mixer iOS and tvOS static libs..."

cd SDL_mixer/Xcode-iOS

build_ios_tvos_lib libSDL_mixer-iOS libSDL2_mixer "GCC_PREPROCESSOR_DEFINITIONS=MUSIC_WAV MUSIC_MID_TIMIDITY MUSIC_OGG OGG_USE_TREMOR OGG_HEADER=<ivorbisfile.h> MUSIC_FLAC FLAC__HAS_OGG HAVE_SYS_PARAM_H HAVE_STDINT_H HAVE_LROUND HAVE_SETENV HAVE_SINF"

cp ../SDL_mixer.h $ios_dir/include/SDL2
cp ../SDL_mixer.h $tvos_dir/include/SDL2

cp build/Release-ios-universal/libSDL2_mixer.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_mixer.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_ttf

task "Building SDL2_ttf iOS and tvOS static libs..."

cd SDL_ttf/Xcode-iOS

build_ios_tvos_lib "Static Library" libSDL2_ttf

cp ../SDL_ttf.h $ios_dir/include/SDL2
cp ../SDL_ttf.h $tvos_dir/include/SDL2

cp build/Release-ios-universal/libSDL2_ttf.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_ttf.a $tvos_dir/lib

cd $tmp_dir

# Make frameworks

build_framework() {

  cd lib
  libtool -static libSDL2.a libSDL2_image.a libSDL2_mixer.a libSDL2_ttf.a -o SDL2
  cd ..

  mkdir -p SDL2.framework/Headers
  cp -R include/SDL2/*.h SDL2.framework/Headers
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

cd $tmp_dir

# Done! ########################################################################

task "Done!"
