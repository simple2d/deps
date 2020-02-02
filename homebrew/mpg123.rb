# Original formula:
#   https://github.com/Homebrew/homebrew-core/blob/master/Formula/mpg123.rb
#
# Changes:
#   - Added `--enable-static`
#   - Removed bottles

class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.13/mpg123-1.25.13.tar.bz2"
  sha256 "90306848359c793fd43b9906e52201df18775742dc3c81c06ab67a806509890a"

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
