# Original formula:
#   https://github.com/Homebrew/homebrew-core/blob/master/Formula/mpg123.rb
#
# Changes:
#   - Added `revision 99` so Homebrew doesn't upgrade the formula
#   - Added `--enable-static`
#   - Removed bottles

class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.28.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.28.0/mpg123-1.28.0.tar.bz2"
  sha256 "e49466853685026da5d113dc7ff026b1b2ad0b57d78df693a446add9db88a7d5"
  license "LGPL-2.1-only"
  revision 99

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --enable-static
    ]

    on_macos do
      args << "--with-default-audio=coreaudio"
    end

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
