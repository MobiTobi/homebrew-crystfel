require "formula"

class Crystfel < Formula
  homepage "http://www.desy.de/~twhite/crystfel/index.html"
  url "http://www.desy.de/~twhite/crystfel/crystfel-0.5.4a.tar.gz"
  sha1 "ce28d2d43ed37f2690f5e026a62acd58065f8ff4"

  option "with-test","runs the test suit"
  option "with-opencl","enables GPU acceleration for pattern_sim"

  depends_on "pkg-config" => :build
  depends_on "gsl"
  depends_on "fftw"
  depends_on "pango"
  depends_on "gdk-pixbuf"
  depends_on "gtk-doc"
  depends_on "gtk+"
  depends_on "hdf5" => "enable-threadsafe"
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-opencl" if build.with? "opencl"

    system "./configure", *args

    system "make"
    system "make install"
    system "make check > #{prefix}/tests.log" if build.with? "test"
  end

  def caveats
    s = <<-EOS.undent
      For indexing diffraction patterns you should install MOSFLM or DirAx.
      The OpenCl option s not supported on OSX yet.
      EOS
  end

  test do
    system "indexamajig --help"
  end
end
