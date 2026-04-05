# typed: false
# frozen_string_literal: true

# Homebrew formula for hazmat.
# Lives in dredozubov/homebrew-tap for: brew install dredozubov/tap/hazmat
#
# After a release, update the url, sha256 values, and version.
# The update-formula.sh script automates this.
class Hazmat < Formula
  desc "AI agent containment for macOS — sandbox, firewall, and credential isolation"
  homepage "https://github.com/dredozubov/hazmat"
  license "MIT"
  version "0.4.2" # updated by release workflow

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dredozubov/hazmat/releases/download/v#{version}/hazmat-v#{version}-darwin-arm64.tar.gz"
      sha256 "9285c79bf62542f76159d06669034317461ac5cfd5502007ff5559a42a5d1b71" # updated by release workflow
    else
      url "https://github.com/dredozubov/hazmat/releases/download/v#{version}/hazmat-v#{version}-darwin-amd64.tar.gz"
      sha256 "46d6240c2fce8f25b9148d1e1dce154d91ae92f28b7feacee7c6a662efcce44c" # updated by release workflow
    end
  end

  depends_on :macos

  def install
    bin.install "hazmat"
    # hazmat-launch requires privileged installation — handled by `hazmat init`.
    # Store it alongside the formula so `hazmat init` can find and install it.
    libexec.install "hazmat-launch"
  end

  def caveats
    <<~EOS
      hazmat-launch (the privileged helper) was placed in:
        #{libexec}/hazmat-launch

      Run `hazmat init` to complete setup. It will install hazmat-launch
      to /usr/local/libexec/ with the correct ownership and permissions.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hazmat --version")
  end
end
