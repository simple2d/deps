#!/bin/bash

# Library URLs #################################################################

sdl_version=2.0.10
sdl_src="https://www.libsdl.org/release/SDL2-${sdl_version}.tar.gz"
sdl_vc="https://www.libsdl.org/release/SDL2-devel-${sdl_version}-VC.zip"
sdl_mingw="https://www.libsdl.org/release/SDL2-devel-${sdl_version}-mingw.tar.gz"

image_version=2.0.5
image_src="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${image_version}.tar.gz"
image_vc="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-${image_version}-VC.zip"
image_mingw="https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-${image_version}-mingw.tar.gz"

mixer_version=2.0.4
mixer_src="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-${mixer_version}.tar.gz"
mixer_vc="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-${mixer_version}-VC.zip"
mixer_mingw="https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-${mixer_version}-mingw.tar.gz"

ttf_version=2.0.15
ttf_src="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${ttf_version}.tar.gz"
ttf_vc="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-${ttf_version}-VC.zip"
ttf_mingw="https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-${ttf_version}-mingw.tar.gz"

glew_version=2.1.0
glew_src="https://github.com/nigels-com/glew/archive/glew-${glew_version}.zip"
glew_release="https://github.com/nigels-com/glew/releases/download/glew-${glew_version}/glew-${glew_version}-win32.zip"

# Directories ##################################################################

headers_dir=`pwd`/headers

vc_sdl_include_dir=`pwd`/vc/SDL2/include
vc_sdl_lib_dir=`pwd`/vc/SDL2/lib
vc_glew_include_dir=`pwd`/vc/glew/include
vc_glew_lib_dir=`pwd`/vc/glew/lib

mingw_bin_dir=`pwd`/mingw/bin
mingw_include_dir=`pwd`/mingw/include
mingw_lib_dir=`pwd`/mingw/lib

homebrew=`pwd`/homebrew

macos_dir=`pwd`/macos
macos_include_dir=$macos_dir/include
macos_lib_dir=$macos_dir/lib

ios_dir=`pwd`/ios
tvos_dir=`pwd`/tvos

# Detect platforms #############################################################

unamestr=$(uname)

# macOS
if [[ $unamestr == 'Darwin' ]]; then
  platform='macos'

# ARM
elif [[ $(uname -m) =~ 'arm' && $unamestr == 'Linux' ]]; then
  platform='arm'

  # Raspberry Pi
  if [[ $(cat /etc/os-release | grep -i raspbian) ]]; then
    platform_rpi=true
  fi

# Linux
elif [[ $unamestr == 'Linux' ]]; then
  platform='linux'

# Windows / MinGW
elif [[ $unamestr =~ 'MINGW' ]]; then
  platform='mingw'
fi

# Helpers ######################################################################

task() {
  printf "\033[1;34m==>\033[1;39m $1\033[0m\n"
}

set -e

# Make and enter temporary directory for libs ##################################

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

extract "SDL2.tar.gz"       "SDL2-${sdl_version}" "SDL"
extract "SDL2-vc.zip"       "SDL2-${sdl_version}" "SDL-vc"
extract "SDL2-mingw.tar.gz" "SDL2-${sdl_version}" "SDL-mingw"

extract "SDL2_image.tar.gz"       "SDL2_image-${image_version}" "SDL_image"
extract "SDL2_image-vc.zip"       "SDL2_image-${image_version}" "SDL_image-vc"
extract "SDL2_image-mingw.tar.gz" "SDL2_image-${image_version}" "SDL_image-mingw"

extract "SDL2_mixer.tar.gz"       "SDL2_mixer-${mixer_version}" "SDL_mixer"
extract "SDL2_mixer-vc.zip"       "SDL2_mixer-${mixer_version}" "SDL_mixer-vc"
extract "SDL2_mixer-mingw.tar.gz" "SDL2_mixer-${mixer_version}" "SDL_mixer-mingw"

extract "SDL2_ttf.tar.gz"       "SDL2_ttf-${ttf_version}" "SDL_ttf"
extract "SDL2_ttf-vc.zip"       "SDL2_ttf-${ttf_version}" "SDL_ttf-vc"
extract "SDL2_ttf-mingw.tar.gz" "SDL2_ttf-${ttf_version}" "SDL_ttf-mingw"

extract "glew.zip"         "glew-glew-${glew_version}" "glew"
extract "glew-release.zip" "glew-${glew_version}"      "glew-release"

# Collect headers ##############################################################

mkdir -p $headers_dir/SDL2

# GLEW
cp glew-release/include/GL/glew.h $headers_dir

# SDL
cp -a SDL/include/*.h    $headers_dir/SDL2
cp SDL_image/SDL_image.h $headers_dir/SDL2
cp SDL_mixer/SDL_mixer.h $headers_dir/SDL2
cp SDL_ttf/SDL_ttf.h     $headers_dir/SDL2

# VC libs ######################################################################

task "Making VC libs..."

mkdir -p $vc_sdl_include_dir
mkdir -p $vc_sdl_lib_dir
mkdir -p $vc_glew_include_dir
mkdir -p $vc_glew_lib_dir

# Copy headers
cp -R $headers_dir/SDL2 $vc_sdl_include_dir
cp $headers_dir/glew.h  $vc_glew_include_dir

copy_sdl_vc() {
  # $1 lib
  cp $1/lib/x64/*.{dll,lib} $vc_sdl_lib_dir
}

copy_sdl_vc "SDL-vc"
copy_sdl_vc "SDL_image-vc"
copy_sdl_vc "SDL_mixer-vc"
copy_sdl_vc "SDL_ttf-vc"

# Use SDL_mixer's version of zlib
cp SDL_image-vc/lib/x64/zlib1.dll $vc_sdl_lib_dir

cp glew-release/bin/Release/x64/glew32.dll \
   glew-release/lib/Release/x64/glew32.lib $vc_glew_lib_dir

# MinGW libs ###################################################################

task "Making MinGW libs..."

mkdir -p $mingw_bin_dir
mkdir -p $mingw_include_dir
mkdir -p $mingw_lib_dir

# Copy headers
cp -R $headers_dir/SDL2 $mingw_include_dir
cp $headers_dir/glew.h  $mingw_include_dir

copy_sdl_mingw() {
  # $1 lib
  cp $1/x86_64-w64-mingw32/bin/*.dll $mingw_bin_dir
  cp $1/x86_64-w64-mingw32/lib/*.a   $mingw_lib_dir
}

copy_sdl_mingw "SDL-mingw"
copy_sdl_mingw "SDL_image-mingw"
copy_sdl_mingw "SDL_mixer-mingw"
copy_sdl_mingw "SDL_ttf-mingw"

cp ../glew-mingw/glew32.dll $mingw_bin_dir
cp ../glew-mingw/libglew32.a ../glew-mingw/libglew32.dll.a $mingw_lib_dir

# macOS libs ###################################################################

if [[ $platform == 'macos' ]]; then

# This assumes that SDL is installed via Homebrew

task "Making macOS libs..."

# brew install sdl2
brew install sdl2

# Install custom `sdl2_mixer` and `mpg123` to get static libraries and linking
brew uninstall --force sdl2_mixer mpg123
brew install $homebrew/mpg123.rb
brew install $homebrew/sdl2_mixer.rb

# Install other Homebrew libs if missing
brew install sdl2_image sdl2_ttf

# Set Homebrew paths
brew_cellar=`brew --cellar`
brew_sdl_dir=$brew_cellar/sdl2/$sdl_version*
brew_image_dir=$brew_cellar/sdl2_image/$image_version*
brew_mixer_dir=$brew_cellar/sdl2_mixer/$mixer_version*
brew_ttf_dir=$brew_cellar/sdl2_ttf/$ttf_version*

# Copy headers
mkdir -p $macos_include_dir
cp -R $headers_dir/SDL2 $macos_include_dir

# Libs

mkdir -p $macos_lib_dir

# SDL2 lib
cp $brew_sdl_dir/lib/libSDL2.a $macos_lib_dir

# SDL2_image libs
cp $brew_image_dir/lib/libSDL2_image.a  $macos_lib_dir
cp $brew_cellar/jpeg/*/lib/libjpeg.a    $macos_lib_dir
cp $brew_cellar/libpng/*/lib/libpng16.a $macos_lib_dir
cp $brew_cellar/libtiff/*/lib/libtiff.a $macos_lib_dir
cp $brew_cellar/webp/*/lib/libwebp.a    $macos_lib_dir

# SDL2_mixer libs
cp $brew_mixer_dir/lib/libSDL2_mixer.a          $macos_lib_dir
cp $brew_cellar/mpg123/*/lib/libmpg123.a        $macos_lib_dir
cp $brew_cellar/libogg/*/lib/libogg.a           $macos_lib_dir
cp $brew_cellar/flac/*/lib/libFLAC.a            $macos_lib_dir
cp $brew_cellar/libvorbis/*/lib/libvorbis.a     $macos_lib_dir
cp $brew_cellar/libvorbis/*/lib/libvorbisfile.a $macos_lib_dir

# SDL2_ttf libs
cp $brew_ttf_dir/lib/libSDL2_ttf.a           $macos_lib_dir
cp $brew_cellar/freetype/*/lib/libfreetype.a $macos_lib_dir

fi  # end if macOS

# iOS and tvOS frameworks ######################################################

if [[ $platform == 'macos' ]]; then

# Use xcpretty for nicer output: gem install xcpretty
if xcpretty -v &>/dev/null; then
  XCPRETTY=xcpretty
else
  task "xcpretty not found!"
  echo -e "  Run \`gem install xcpretty\` for nicer xcodebuild output."
  XCPRETTY=cat
fi

mkdir -p $ios_dir/lib
mkdir -p $tvos_dir/lib

build_ios_tvos_lib() {
  scheme=$1
  fname=$2
  env1=$3
  env2=$4

  # Ignore empty environment variable args, replace with dummy var
  if [[ $env1 == '' ]]; then env1="A="; fi
  if [[ $env2 == '' ]]; then env2="A="; fi
  
  SIMULATOR_PATH="build/${fname}-iphonesimulator"
  DEVICE_PATH="build/${fname}-iphoneos"

  task "Building $fname for iPhone..."
  buildDir="BUILD_DIR=$DEVICE_PATH"
  xcodebuild -scheme "$scheme" -configuration Release -sdk iphoneos  SKIP_INSTALL=NO "$env1" "$env2" "$buildDir" | $XCPRETTY

  task "Building $fname for iPhone Simulator..."
  buildDir="BUILD_DIR=$SIMULATOR_PATH"

  xcodebuild -scheme "$scheme" -configuration Release -sdk iphonesimulator SKIP_INSTALL=no "$env1" "$env2" "$buildDir" | $XCPRETTY

  task "Combining all frameworks..."
  xcodebuild -create-xcframework -framework ${SIMULATOR_PATH}/Products/Library/Frameworks/${fname}.framework -framework ${DEVICE_PATH}/Products/Library/Frameworks/${fname}.framework -output ${OUTPUT_DIR}/${fname}.xcframework
}

# Build SDL2

task "Building SDL2 iOS and tvOS static libs..."

cd SDL/Xcode/SDL

build_ios_tvos_lib "Static Library-iOS" libSDL2

cp build/Release-ios-universal/libSDL2.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_image

task "Building SDL2_image iOS and tvOS static libs..."

cd SDL_image/Xcode-iOS

build_ios_tvos_lib libSDL_image-iOS libSDL2_image

cp build/Release-ios-universal/libSDL2_image.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_image.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_mixer

task "Building SDL2_mixer iOS and tvOS static libs..."

cd SDL_mixer/Xcode-iOS

build_ios_tvos_lib libSDL_mixer-iOS libSDL2_mixer "GCC_PREPROCESSOR_DEFINITIONS=MUSIC_WAV MUSIC_MID_TIMIDITY MUSIC_OGG OGG_USE_TREMOR OGG_HEADER=<ivorbisfile.h> MUSIC_FLAC FLAC__HAS_OGG HAVE_SYS_PARAM_H HAVE_STDINT_H HAVE_LROUND HAVE_SETENV HAVE_SINF"

cp build/Release-ios-universal/libSDL2_mixer.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_mixer.a $tvos_dir/lib

cd $tmp_dir

# Build SDL2_ttf

task "Building SDL2_ttf iOS and tvOS static libs..."

cd SDL_ttf/Xcode-iOS

build_ios_tvos_lib libSDL_ttf-iOS libSDL2_ttf

cp build/Release-ios-universal/libSDL2_ttf.a $ios_dir/lib
cp build/Release-tvos-universal/libSDL2_ttf.a $tvos_dir/lib

cd $tmp_dir

# Make frameworks

build_framework() {

  cd lib
  libtool -static libSDL2.a libSDL2_image.a libSDL2_mixer.a libSDL2_ttf.a -o SDL2
  cd ..

  mkdir -p SDL2.framework/Headers
  cp -a $headers_dir/SDL2/. SDL2.framework/Headers
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
rm -r lib

cd ../tvos
build_framework
rm -r lib

cd $tmp_dir

fi  # end if macOS

# Done! ########################################################################

task "Done! 😅"
