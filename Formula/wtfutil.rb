class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.26.0",
    :revision => "7ab898c718e693e76a930e334bb0c2836d4cf2d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bfaf819f82207cff3b250e241811560dd43e173dc00c02797d236a3399c57f0" => :catalina
    sha256 "dd51d724abec286fac671ad7793f92dbeeedd047158b07ced6de9a0ebb39224a" => :mojave
    sha256 "e50fa8b68c47b82593c33bd72602edefa8ad8f8675012ff6e392b14a56ce77cf" => :high_sierra
    sha256 "8ebeec1074ea3f2a8ff704d0aa074aefb096e62260667044cd415d7dd5743c0a" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://gocenter.io"
    ldflags=["-s -w -X main.version=#{version}",
             "-X main.date=#{Time.now.iso8601}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
