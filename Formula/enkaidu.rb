#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://github.com/enkaidu-dev/enkaidu"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.8.0.tar.gz"
  sha256 "e1752378d4aed750518fe54a5eecab14efe0c90f392e68f1f4f1562b194708d5"
  license "MPL-2.0"

  depends_on "crystal" => :build
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "node"
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
