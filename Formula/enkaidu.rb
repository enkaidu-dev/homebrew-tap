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
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.7"
    sha256 cellar: :any, arm64_sequoia: "55f5b39f37738566f67479d63fa5edcdeb27cdf7854d39ecb02f75885ceb990f"
    sha256 cellar: :any, arm64_linux:   "2100a298cfaaa3354106a8ece1b5e0db0ae5bc909f6013bb47fe03e87887784a"
    sha256 cellar: :any, x86_64_linux:  "16856059f0e598f221161867246d54e2abb584cee6a867f78110876664595e76"
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
