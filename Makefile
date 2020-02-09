
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

clean: remove-xcode-user-data
	if [ -d "tmp" ]; then find tmp -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;; fi
	rm -rf headers/*
	rm -rf vc/*
	rm -rf mingw/*
	rm -rf macos/*
	rm -rf ios/*
	rm -rf tvos/*

uninstall: uninstall-simple2d uninstall-sdl

reset: clean uninstall
