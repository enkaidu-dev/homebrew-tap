#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc "CLI tool to use self-hosted AI models for local editing and refinement tasks"
  homepage "https://enkaidu.dev"
  url "https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.15.tar.gz"
  sha256 "8ae3486c3760ef4e15d9e1f4f913c1d9da6ccbe26af35bf51b8d812e20476bfa"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.15"
    sha256 arm64_tahoe:  "d41f77294e33315529d643ddafaf021506d114f035fe1e88336420d37c3daf4d"
    sha256 arm64_linux:  "4527dba3e688c1056c713601f29d9cb3621d66bddf1fbe153ab1e1998d23af97"
    sha256 x86_64_linux: "1e5fb531df25bc75109d81ceef6fcdca8a63010d828346fe36ea85e21eadf8de"
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
