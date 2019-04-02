# Removed `depends_on "libmodplug"`
# Added `depends_on "flac"`
# Added `depends_on "libogg"`
# Added `depends_on "mpg123"`
# Replaced all `args` with below, adding `--disable-music-xxx-shared` to link statically
# Removed bottles

class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
  sha256 "b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-music-mod-modplug-shared
      --disable-music-mod-mikmod-shared
      --disable-music-midi-fluidsynth-shared
      --disable-music-ogg-shared
      --disable-music-flac-shared
      --disable-music-mp3-mpg123-shared
      --disable-music-opus-shared
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_mixer", "test.c", "-o", "test"
    system "./test"
  end
end
