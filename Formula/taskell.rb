require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.2.tar.gz"
  sha256 "2cb633013a35bfb5cced81fc132a6789a3c69d32e8f4aac820ab266f6fc2470a"

  bottle do
    cellar :any_skip_relocation
    sha256 "111fd4a43d0dd5053517872aaa1fdf8cceb24b212ffa422e580db44b93f3a37f" => :catalina
    sha256 "9e18af03b8c6cd94d01724f6d7247f48b92c73c11eb0c14176ce5ade0d0f47a7" => :mojave
    sha256 "78819149a4d0cd8e528d64b4b37ddc9f98c2a1aa56c0a223fb062b8be06530e3" => :high_sierra
    sha256 "e5ff98b60c6410274383f138876791fc852fc95a514343e8511396620c2af079" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}/taskell -i test.md")
  end
end
