
all:
	bash build.sh

install-simple2d:
	brew tap simple2d/tap
	brew install simple2d

uninstall-simple2d:
	brew uninstall --force simple2d

# Uninstall all SDL2-related libs using Homebrew
uninstall-sdl:
	brew uninstall --force --ignore-dependencies \
	  sdl2_ttf freetype \
	  sdl2_mixer mpg123 fluidsynth portaudio libsndfile libvorbis flac libogg libmodplug libmikmod \
	  sdl2_image libpng jpeg libtiff webp \
	  sdl2

remove-xcode-user-data:
	find ./xcode -name "xcuserdata" -type d -exec rm -r "{}" \;

clean:
	if [ -d "tmp" ]; then find tmp -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;; fi
	rm -rf vc/*
	rm -rf mingw/*
	rm -rf macos/*
	rm -rf ios/*
	rm -rf tvos/*

clean-all: uninstall-simple2d uninstall-sdl remove-xcode-user-data clean
