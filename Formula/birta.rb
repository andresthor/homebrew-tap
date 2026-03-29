class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/andresthor/birta"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andresthor/birta/releases/download/v0.1.1/birta-aarch64-apple-darwin.tar.xz"
      sha256 "5552115e69046f29d453a32f672e0f3165fd2024dfd80810cdce3e8f766034e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andresthor/birta/releases/download/v0.1.1/birta-x86_64-apple-darwin.tar.xz"
      sha256 "fa393b4049b479a7ff9f672812c243030c1bacd2134953905cf2b23deb320f9d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andresthor/birta/releases/download/v0.1.1/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe14a3a283bc423ecb85417bc2ac7b197a66600d29fe8da756f4073737e7a2b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andresthor/birta/releases/download/v0.1.1/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "947a2f6c27ddc7e9376c3262572144c84845ba2ffd786e1974dd28cb4109e536"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "birta" if OS.mac? && Hardware::CPU.arm?
    bin.install "birta" if OS.mac? && Hardware::CPU.intel?
    bin.install "birta" if OS.linux? && Hardware::CPU.arm?
    bin.install "birta" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
