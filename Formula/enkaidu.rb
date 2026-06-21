#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.6.tar.gz"
  sha256 "e1976b5c8292b07b6ea780e00e9ffd6c7797f29a1e34f0e2bb6898a504a019d3"
  license "MPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.6_1"
    sha256 cellar: :any, arm64_sequoia: "46368095668487e73105d1ea063ea3d36ff36166f5281d42ddfb3c164eba0564"
    sha256 cellar: :any, arm64_linux:   "dcd90c424943902f1c86664a98f30cc49b757372cb13dec2559963392f007eff"
    sha256 cellar: :any, x86_64_linux:  "7f315bc0c1de4580fdd81ddb502a619243e6eaaf6d38a45d56dc7fa78885fe4d"
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
