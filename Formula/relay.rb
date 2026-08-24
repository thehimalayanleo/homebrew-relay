class Relay < Formula
  desc "Shared workspaces and verified handoffs for people and AI agents"
  homepage "https://github.com/thehimalayanleo/relay"
  url "https://github.com/thehimalayanleo/relay/archive/cff60f1f2ce040520fb881dd12a76e4584ac7bbf.tar.gz"
  version "0.1.0"
  sha256 "613172909ec5ec7b8faf8e1886a58346c33e838506fc3d5f849801dab468d0ee"
  license "MIT"

  depends_on "node@22"

  def install
    system "npm", "install", *std_npm_args
    node_path = "#{Formula["node@22"].opt_bin}:$PATH"
    (bin/"relay").write_env_script libexec/"bin/relay", PATH: node_path
    (bin/"relay-core").write_env_script libexec/"bin/relay-core", PATH: node_path
    (bin/"relay-opencode-runner").write_env_script libexec/"bin/relay-opencode-runner", PATH: node_path
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
