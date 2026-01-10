#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "A command line tool that can use local and remote AI models to assist with local editing and refinement tasks."
  homepage "https://github.com/enkaidu-dev/enkaidu"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.8.0.zip"
  sha256 "e1752378d4aed750518fe54a5eecab14efe0c90f392e68f1f4f1562b194708d5"
  license "MPL-2.0"

  depends_on "crystal" => :build
  depends_on "node"
  depends_on "libevent"
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