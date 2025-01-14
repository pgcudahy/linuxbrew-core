require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.29.tgz"
  sha256 "e7dc2b2a9e3e63a6b15810e7be0988dc9bea5466b5172c17a65abe5d1da9b6ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "84cf62a0747b8df3568e930cca692fda5d9dfeebb4974d01dee1125385441d7e" => :catalina
    sha256 "464d377d019980673e1137a9d5395e7177a37afa56e6de69c1c7f58682f49b54" => :mojave
    sha256 "c62a71b160104b1864a83f4b095cf23ec789d8aa9114e09d292ecf2d124d8d1d" => :high_sierra
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    if !OS.mac? && ENV["CI"]
      system "git", "config", "--global", "user.email", "you@example.com"
      system "git", "config", "--global", "user.name", "Your Name"
    end
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
