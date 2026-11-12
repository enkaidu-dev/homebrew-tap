#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.18.tar.gz"
  sha256 "c13ccfa7e754a8f118abf9cd7d1328fd3ccd9e61e6b1d6a529d56a56b89ffc84"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.18"
    sha256 arm64_tahoe:  "7fc39e8ae4dd38670d64aa715b0b7feb348ebaee9b80e274e553db0f65cefc25"
    sha256 arm64_linux:  "1d2890ce279f07db46363b8ac3c355113d0b9020358eb109dd208fb150bd45cd"
    sha256 x86_64_linux: "7ac3f27fcc35e4a7afa5c4d54ef15a2dcd9fb848fb89b6dc064fb422d92261ba"
  end

  depends_on "crystal" => :build
  depends_on "node" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"

  depends_on "zlib-ng-compat" if OS.linux?

  def install
    # Build the web UI dist
    system("cd webui && npm i && npm run build && cd ..")
    # Skip postinstall since mime_map's script fails
    system("shards", "install", "--production", "--skip-postinstall")
    # Manually run the mime_map code gen
    system("cd lib/mime_map && make gen && cd ..")
    # Now build Enkaidu
    system("shards", "--production", "build", "--release")
    bin.install "bin/enkaidu"
  end

  test do
    system "#{bin}/enkaidu", "--help"
  end
end
