class Relay < Formula
  desc "Shared workspaces and verified handoffs for people and AI agents"
  homepage "https://github.com/thehimalayanleo/relay"
  url "https://github.com/thehimalayanleo/relay/archive/4ea214f.tar.gz"
  version "0.1.0"
  sha256 "ceeecf578704cc54ebc834093e1ba7e91749e851eada401c515114f9925c1e46"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/relay"
    bin.install_symlink libexec/"bin/relay-core"
    bin.install_symlink libexec/"bin/relay-opencode-runner"
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
      Host setup:
        relay configure
        relay serve --host 0.0.0.0 --public-url http://<tailscale-name>:4317

      Or run it as a local background service:
        brew services start relay

      Collaborators only open the generated invite link. They need no installation or keys.
    EOS
  end

  test do
    assert_match "Relay CLI", shell_output("#{bin}/relay --help")
  end
end
