class Relay < Formula
  desc "Shared workspaces and verified handoffs for people and AI agents"
  homepage "https://github.com/thehimalayanleo/relay"
  url "https://github.com/thehimalayanleo/relay/archive/cd57a34a98e840acacca006e45e0bd99fe2e3191.tar.gz"
  version "0.1.0"
  sha256 "3fd99fb5bf9eb5f1e7a1d261df0ad00240be1e7b43da69c94da40146b56ee181"
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
                          RELAY_POD_DIR: var/"relay/pods"
  end

  def caveats
    <<~EOS
      Start Relay:
        relay configure
        relay serve

      Or run it as a local background service:
        brew services start relay

      Dashboard:
        http://127.0.0.1:4317/demo/greptile?role=pm
    EOS
  end

  test do
    assert_match "Relay CLI", shell_output("#{bin}/relay --help")
  end
end
