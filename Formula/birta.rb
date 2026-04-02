class Birta < Formula
  desc "Preview markdown files in the browser with GitHub-style rendering"
  homepage "https://github.com/andresthor/birta"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/andresthor/birta/releases/download/v0.2.0/birta-aarch64-apple-darwin.tar.xz"
      sha256 "00f0541d1eab6794118811be43bfb86ad213a18c51328d592fbe28d12962e3b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andresthor/birta/releases/download/v0.2.0/birta-x86_64-apple-darwin.tar.xz"
      sha256 "643ed1323e4627ad6fedd7ba3333e9cc8519762049261b0a60d10b57adaa6d6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/andresthor/birta/releases/download/v0.2.0/birta-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60a3a34f4b2ae17a9f6df78d2a0fd15e0f0abe1610f5a62f63a4aee1e694af51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/andresthor/birta/releases/download/v0.2.0/birta-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0a31323a30c821d3f60f62b476bf463cc69851fd40cc6d5cb8618015a97b03d9"
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
