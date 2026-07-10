#
# Inspired by github.com/nickthecook/homebrew-crops
#
class Enkaidu < Formula
  desc 'CLI tool to use self-hosted AI models for local editing and refinement tasks'
  homepage 'https://enkaidu.dev'
  url 'https://github.com/enkaidu-dev/enkaidu/archive/refs/tags/0.9.10.tar.gz'
  sha256 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
  license 'MPL-2.0'

  bottle do
    root_url 'https://github.com/enkaidu-dev/homebrew-tap/releases/download/enkaidu-0.9.9'
    sha256 cellar: :any, arm64_sequoia: '9b01b26d0856362ede946e5dfeaa81c7ce5604a85fc9df31ab5f9c4e3b5695ad'
    sha256 cellar: :any, arm64_linux:   'd4446fba04eec2c1778ab63bf30e088691165419a62007c933238e6fe7b9c182'
    sha256 cellar: :any, x86_64_linux:  'f3dda97f4d675e3964322da7acf82f3f66a4c1117cb8607a754b1c87b6055747'
  end

  depends_on 'crystal' => :build
  depends_on 'node' => :build
  depends_on 'bdw-gc'
  depends_on 'libevent'
  depends_on 'libxml2'
  depends_on 'libyaml'
  depends_on 'openssl@3'
  depends_on 'pcre2'

  depends_on 'zlib-ng-compat' if OS.linux?

  def install
    system('cd webui && npm i && npm run build && cd ..')
    local_crystal_path = `crystal env CRYSTAL_PATH`.chomp
    system("CRYSTAL_PATH='src:lib:#{local_crystal_path}' shards build --release")
    bin.install 'bin/enkaidu'
  end

  test do
    system "#{bin}/enkaidu", '--help'
  end
end
