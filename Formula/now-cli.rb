require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-17.0.1.tgz"
  sha256 "12bf6a35c09593df9a8e02dac87fb1d03e86f3c166813e5e5dddf031ddc2f724"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c05c1ced60ece02ab234078a142c44b10ca97dbfc4befb3633a114cdeb5c924" => :catalina
    sha256 "0201f12c17dcca561b9e45e42b8bfc61f74cc611a95933b97aba8c9efcac4b60" => :mojave
    sha256 "501c12b0df143c9c50daa7e856ca228494379daf6c3bfa8ca1de692bacf049b4" => :high_sierra
    sha256 "0821b1d612ea8d10730aca2fa4e375147991c67975996724dc9bfe8873e9f947" => :x86_64_linux
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
