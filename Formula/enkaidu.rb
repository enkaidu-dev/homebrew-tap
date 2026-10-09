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
    root_url "https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.14"
    sha256 arm64_tahoe:  "07c19b553d95cb2c0d2b798f97e6d3929aac00a0cb6726a65138e12fd065ee0d"
    sha256 arm64_linux:  "ab5fd1abe1d77e5656d14c6e2da7d02968b1224f2dce226cc8932769f6cbd82e"
    sha256 x86_64_linux: "a45fd1358e35e6c1cf71bd5deb59c0b0f9ebc768d3d2d506bd30cdb7a83a0531"
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
