class Relay < Formula
  desc "Shared workspaces and verified handoffs for people and AI agents"
  homepage "https://github.com/thehimalayanleo/relay"
  url "https://github.com/thehimalayanleo/relay/archive/b70633c.tar.gz"
  version "0.1.0"
  sha256 "a4b2b1d89102e78a869a40a61d3bb29175bdfe1d10fea9dc549049a9899646c5"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/relay"
    bin.install_symlink libexec/"bin/relay-core"
  end

  service do
    run [opt_bin/"relay", "serve"]
    keep_alive true
    working_dir var/"relay"
    log_path var/"log/relay.log"
    error_log_path var/"log/relay.log"
    environment_variables RELAY_DATA_DIR: var/"relay/data",
                          RELAY_POD_DIR:  var/"relay/pods"
  end

  def caveats
    <<~EOS
      Start Relay:
        relay configure
        relay serve

      Or run it as a local background service:
        brew services start relay

      Dashboard:
        http://127.0.0.1:4317/demo/greptile
    EOS
  end

  test do
    assert_match "Relay CLI", shell_output("#{bin}/relay --help")
  end
end
