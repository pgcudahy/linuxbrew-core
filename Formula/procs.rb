class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.6.tar.gz"
  sha256 "a8b4aed17cbba595b49abcfb00c41ecf7e992c3f64b28df3ad6549c9bd1e1af1"

  bottle do
    cellar :any_skip_relocation
    sha256 "afb83ea340dd2d4afc89e897e1d300b74a3cbbc00b43a956ecfca79a0d30b291" => :catalina
    sha256 "7df07639eca8edd6382ef39b8c04fbe62b130f9125e9a617ba5d1d28c27c7a94" => :mojave
    sha256 "2d77df66127b1ad242cad0250aeca50c1c8692061d5c405ea7b17604b636c8ee" => :high_sierra
    sha256 "fd9aa2a2e652553d282623bf4765f8e784ef87b0ef808252bd67bbadf8e04cdd" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
