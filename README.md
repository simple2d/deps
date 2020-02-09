# Dependencies for Simple 2D

This contains development libraries and assets needed by Simple 2D. External libraries included are:

- Simple DirectMedia Layer (SDL)
  - [SDL2 2.0.10](https://www.libsdl.org)
  - [SDL2_image 2.0.5](https://www.libsdl.org/projects/SDL_image)
  - [SDL2_mixer 2.0.4](https://www.libsdl.org/projects/SDL_mixer)
  - [SDL2_ttf 2.0.15](https://www.libsdl.org/projects/SDL_ttf)
- OpenGL Extension Wrangler Library (GLEW)
  - [GLEW 2.1.0](http://glew.sourceforge.net)

[View licenses](LICENSES.md) for all libraries above.

## Contents

- [`glew-mingw/`](glew-mingw) — Pre-built library binaries for GLEW on MinGW (see README in directory for details)
- [`headers`](headers)
- [`homebrew/`](homebrew) — Custom [Homebrew](https://brew.sh) formulas
- [`ios/`](ios) — iOS SDL framework, built by [`build.sh`](build.sh)
- [`macos/`](macos) — macOS static libraries, built by [`build.sh`](build.sh)
- [`mingw/`](mingw) — MinGW static and runtime libraries, downloaded and organized from pre-built source
- [`tmp/`](tmp) — Temporary directory used by the build process
- [`tvos/`](tvos) — tvOS SDL framework, built by [`build.sh`](build.sh)
- [`vc/`](vc) — Visual C++ static and runtime libraries, downloaded and organized from pre-built source
- [`xcode/`](xcode) — Xcode projects and assets (see README in directory for details)

## Building libraries

Run `make` to build everything (and optionally `make uninstall` and `make clean` before starting). The primary build script is [`build.sh`](build.sh) and is designed to be run on macOS (to build macOS, iOS, and tvOS libraries). See the [`Makefile`](Makefile) for other helpful commands.

## Caveats

- Homebrew has a few outdated or mis-configured formulas for our needs. Updated formulas are in the [`homebrew/`](homebrew) directory, with changes made to the formula described in comments at the top of each.

## Updating

To update the libraries in this repo, do the following:

- Update the SDL version numbers in [`build.sh`](build.sh)
- Update the Homebrew formulas in [`homebrew/`](homebrew) (version numbers, etc.)
- Update [`glew-mingw/`](glew-mingw) (follow README in that directory)
- Update Xcode projects in [`xcode/`](xcode) directory
- Run `make clean && make` to rebuild everything
