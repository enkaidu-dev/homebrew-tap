#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.16.tar.gz"
  sha256 "aeaf6ba20227dbfbe5048f0369978a5f3d16912ccd1b5732d04419bb515e4762"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.16"
    sha256 arm64_tahoe:  "69e899dd3abbf4f6a541e646bcd501cff5866105d8baeb8dfe1269df817b73fd"
    sha256 arm64_linux:  "fd0998b799e7c987a8d05a76cd6e8591c8da0ade5a14073afa5316235b73d36f"
    sha256 x86_64_linux: "f09e8122e80e222182c2b696fa360fa0518a980f908b9edbefcf20120cfffdfe"
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
