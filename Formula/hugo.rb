class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.64.0.tar.gz"
  sha256 "e9f6cde1d40ae75e7573ad86829fbb5cb0951e70d3e4ec25850c3d9690022572"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afbeb612b916a995aa67042dd2e8163d0d5abd4c8854aae7c530770377cd271c" => :catalina
    sha256 "300aa7dce6eebb2aeff974e273e2bf3f877410b4d0a598a11ca7b91d3e8daf1c" => :mojave
    sha256 "05f6d81c92ddd9766aae19573845d4fd84407a9ce2a9d75f591e99cd687c72dc" => :high_sierra
    sha256 "5a10e888eceaf695b8a0eb6f51eaf1b22d8a288b36302ccc97a3643f07c3603b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
