#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://github.com/enkaidu-dev/enkaidu"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.8.5.tar.gz"
  sha256 "f21e07049be9b4fbf29744e1eb45f0e709acc3530e82dbd9748e5ba32102beb2"
  license "MPL-2.0"

  depends_on "crystal" => :build
  depends_on "node" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "libyaml"
  depends_on "pcre2"

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
