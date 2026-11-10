#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.17.tar.gz"
  sha256 "c66eee6cf6dfaaea73bd903c6315128d9abc7fb9ab509fbd36458ddaaf0480bb"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.17"
    sha256 arm64_tahoe:  "301522697be90a76b7eae8a994564e0aacdfb733effcd1db25aaf09f22a9f0e7"
    sha256 arm64_linux:  "6b3e33de892beed2247676d0cfebecb3a1e987fb0a56e90ce76cd77cbbdec476"
    sha256 x86_64_linux: "52bd8f02b27b3d3c44fa4479ad01aee9ba93f20ba68fd0805c7b53902f6b2473"
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
