class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.99.0.tar.gz"
  sha256 "0c490cdd252180d401577c70074886644a4cdcf93abea3dcd878dc7819605cb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6db438757918f8cf0f7db535fd87764006fcec67be04f33b59878e669d58cfd" => :catalina
    sha256 "9cc8f043ed41b5b7d4c6c0ba3e616f1c7e1d31fb77c94f0c8835fa81741b64f2" => :mojave
    sha256 "912f944cea0c4ae64a28bb124da57fe146366658d15f30a575d8d523ca2234e5" => :high_sierra
    sha256 "ddcdfca865fe32d15ebbf3f85c0259ec64794438b2e11c2f3d6c2437bb42c0f0" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
