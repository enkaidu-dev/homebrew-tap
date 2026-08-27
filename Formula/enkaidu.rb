#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.11.tar.gz"
  sha256 "f559f8822f336bf52bc8b1671ae99570769dad9fd3a8aaae7e146658458fead3"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.10"
    sha256 cellar: :any, arm64_tahoe:  "4b0f6841cce9d6a50ff71586e631fe3c30330b7e22e1ab9eac491a148b3cecd7"
    sha256 cellar: :any, arm64_linux:  "04371a1bbc0035c7d26d4ce81b1c222d42827476f9abfff720da32f7d16faab5"
    sha256 cellar: :any, x86_64_linux: "1d529a64f2d0274f5f0018bfd183a2899dab1d00807554a6777886f782d4ea9c"
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
