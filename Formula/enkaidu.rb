#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.8.tar.gz"
  sha256 "2ae34599f18dd4a2c934b0199ae487c491986cefa832804a747f246cafbf2454"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.8"
    sha256 cellar: :any, arm64_tahoe:  "f997b16aa00bf132dc476631dae5680808502dd896b124112bdc3c15fac7877e"
    sha256 cellar: :any, arm64_linux:  "b571d28549a19fd3f456b722ee4e3a3396c04fc62e7f4a5658ac00ca04058892"
    sha256 cellar: :any, x86_64_linux: "8cfe42ed6b46a754e2d0c7c0eefb20ff5f95045465e27dcd2e976e0f2e99c630"
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
