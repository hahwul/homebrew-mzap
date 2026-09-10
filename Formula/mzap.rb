# typed: strict
# frozen_string_literal: true

# This file is rendered by mzap's release pipeline (.github/workflows/publish-homebrew-tap.yml).
# DO NOT EDIT by hand.
class Mzap < Formula
  desc "Multi-target ZAP scanning CLI with multi-host dispatch and reporting"
  homepage "https://github.com/hahwul/mzap"
  version "2.2.1"
  license "MIT"

  on_macos do
    # macOS ships a tarball holding the binary and its bundled OpenSSL under
    # lib/. scripts/package-macos.sh rewrites the load paths to
    # @executable_path/lib and asserts no Homebrew prefix survives, so there is
    # deliberately no openssl dependency here.
    on_arm do
      url "https://github.com/hahwul/mzap/releases/download/v2.2.1/mzap-v2.2.1-osx-arm64.tar.gz"
      sha256 "204b20e032bf82de796c84b012259035a4edf2928ab59a17a0d433aadd7d990d"
    end
    on_intel do
      url "https://github.com/hahwul/mzap/releases/download/v2.2.1/mzap-v2.2.1-osx-x86_64.tar.gz"
      sha256 "5eb73b8959d250f9a1f91b6c7decf80fab9e6e4ff4d6d1b8e6ae493359634b29"
    end
  end

  on_linux do
    # Linux release binaries are statically linked, so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/mzap/releases/download/v2.2.1/mzap-v2.2.1-linux-arm64"
      sha256 "82db5c39717608dca303d882b95bf05f55f6a14672f6e8381e25622c7a8f7d7a"
    end
    on_intel do
      url "https://github.com/hahwul/mzap/releases/download/v2.2.1/mzap-v2.2.1-linux-x86_64"
      sha256 "9545476bf4c555cb49c44da51e521d3e7658ac8dd0cc2744e9ca408392dbd2d9"
    end
  end

  def install
    if OS.mac?
      # The binary resolves its OpenSSL through @executable_path/lib, so the
      # two must stay adjacent. Keep the pair in libexec and expose the binary
      # via a symlink: dyld resolves @executable_path from the real path, so
      # lib/ is still found. Installing the binary alone into bin fails at
      # launch with "libssl.3.dylib not found".
      libexec.install "mzap", "lib"
      bin.install_symlink libexec/"mzap"
    else
      bin.install Dir["mzap-v2.2.1-*"].first => "mzap"
    end
  end

  test do
    system "#{bin}/mzap", "version"
  end
end
