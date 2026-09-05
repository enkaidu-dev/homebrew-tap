#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.12.tar.gz"
  sha256 "2e5b8e264f4953d1a28fc95be27a618834985421d1822a6ebbf01968da50c8f2"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.12"
    sha256 arm64_tahoe:  "2d71583d8956626fcb752bc36e184a76d9fa691acdc3bf6252beb04223e0cb5b"
    sha256 arm64_linux:  "7c0c2d218462fac8a9750c522f395689b94b41488bc62a78bb2fddf4fd2b6f42"
    sha256 x86_64_linux: "c3cb51e7610694b9cbfbdca1d137aa9cc7ae30f885536663f9fe89bd16740fa8"
  end

  depends_on "crystal" => :build
  depends_on "node" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  depends_on "zlib-ng-compat" if OS.linux?

  def install
    system("cd webui && npm i && npm run build && cd ..")
    local_crystal_path = `crystal env CRYSTAL_PATH`.chomp
    system("CRYSTAL_PATH='src:lib:#{local_crystal_path}' shards build --release")
    bin.install "bin/enkaidu"
  end

  test do
    system "#{bin}/enkaidu", "--help"
  end
end
