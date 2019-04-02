# Added `--enable-static`
# Removed bottles

class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.10/mpg123-1.25.10.tar.bz2"
  sha256 "6c1337aee2e4bf993299851c70b7db11faec785303cfca3a5c3eb5f329ba7023"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-static
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
