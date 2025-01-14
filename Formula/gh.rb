class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.5.2.tar.gz"
  sha256 "bdd7c8681b711d0d1d4dc027c06ab88e89d2f43af40eba6865cad52ee460bec9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b638459317ff5db4ed5e108af723d672ceae2aa53443c356304b9814f957af5" => :catalina
    sha256 "d11f585adaf02665348cb4bcb06ebc4d83b13ce6f61de38adce66ff1129a7593" => :mojave
    sha256 "42a709ad95939bb6d8341aec1bf5ae3a9568263cbfd05c47d9905678ef75c744" => :high_sierra
    sha256 "7b78df55edca968f81c5f825a6fb5dc62e25a667e8ddcd46a237657708c83dd0" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/name, "./cmd/gh"

    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1")
  end
end
