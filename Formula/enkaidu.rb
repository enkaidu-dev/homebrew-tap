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
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.11"
    sha256 arm64_tahoe:  "3082c14142c9ada2df1a96ec091112c1f91718f6cf2855ef1eaba134451dba07"
    sha256 arm64_linux:  "f1bf6c22f2580a411fea84c250f6e173ec17abfdab1fb6d0934761ae307ef870"
    sha256 x86_64_linux: "8309b8372596bb970ad4e5389ecd58b56cb4290cd890338a458ccd4bfdfb1161"
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
