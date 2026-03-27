#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.8.9.tar.gz"
  sha256 "0bf0e901002fed9d2db0c2f8146f7cfba706c496d9c7477359a818c07d66f637"
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
