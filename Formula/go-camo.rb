class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "1182573507a50e95aa11cbd283a9d691b86b8f7c16f61b2dd7320e2aef1a2594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15d20e46db26d6f93b3cd7b5ebe4f66a94298ae11b9fffed0859b2eb08b63a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d20e46db26d6f93b3cd7b5ebe4f66a94298ae11b9fffed0859b2eb08b63a1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15d20e46db26d6f93b3cd7b5ebe4f66a94298ae11b9fffed0859b2eb08b63a1f"
    sha256 cellar: :any_skip_relocation, ventura:        "6f52fb6a920d48725532416a8a9dfa782dd9a5fdbdb67fec4123dffa3c3e9b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f52fb6a920d48725532416a8a9dfa782dd9a5fdbdb67fec4123dffa3c3e9b0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f52fb6a920d48725532416a8a9dfa782dd9a5fdbdb67fec4123dffa3c3e9b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e23e6abe9d32550a96f6bc00b291b9fef4986e528f2cb48c6d16929eb6089c6"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    fork do
      exec bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "http://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
