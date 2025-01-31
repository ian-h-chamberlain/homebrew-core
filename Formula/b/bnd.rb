class Bnd < Formula
  desc "Swiss Army Knife for OSGi bundles"
  homepage "https://bnd.bndtools.org/"
  url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/6.4.1/biz.aQute.bnd-6.4.1.jar"
  sha256 "71108848bf44b7521afc7d6f63613ac1ffef8d41bf92588a1ec196bfb05fea19"
  license any_of: ["Apache-2.0", "EPL-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb9cf40a41266b51c26d7feaaad7bcc60147e6fd0facc0f559008eb80390d806"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9cf40a41266b51c26d7feaaad7bcc60147e6fd0facc0f559008eb80390d806"
    sha256 cellar: :any_skip_relocation, ventura:        "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a72b84f857a282a23dac9e995d4462d59c74430da39cd71eb0e28aefba8111cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721b378810b533d58c4ed3d98dd94e31949cad601665f2eec90704e2bf4165fc"
  end

  depends_on "openjdk"

  def install
    libexec.install "biz.aQute.bnd-#{version}.jar"
    bin.write_jar_script libexec/"biz.aQute.bnd-#{version}.jar", "bnd"
  end

  test do
    # Test bnd by resolving a launch.bndrun file against a trivial index.
    test_sha = "baad835c6fa65afc1695cc92a9e1afe2967e546cae94d59fa9e49b557052b2b1"
    test_bsn = "org.apache.felix.gogo.runtime"
    test_version = "1.0.0"
    test_version_next = "1.0.1"
    test_file_name = "#{test_bsn}-#{test_version}.jar"
    (testpath/"index.xml").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <repository increment="0" name="Untitled" xmlns="http://www.osgi.org/xmlns/repository/v1.0.0">
        <resource>
          <capability namespace="osgi.identity">
            <attribute name="osgi.identity" value="#{test_bsn}"/>
            <attribute name="type" value="osgi.bundle"/>
            <attribute name="version" type="Version" value="#{test_version}"/>
          </capability>
          <capability namespace="osgi.content">
            <attribute name="osgi.content" value="#{test_sha}"/>
            <attribute name="url" value="#{test_file_name}"/>
          </capability>
        </resource>
      </repository>
    EOS

    (testpath/"launch.bndrun").write <<~EOS
      -standalone: ${.}/index.xml
      -runrequires: osgi.identity;filter:='(osgi.identity=#{test_bsn})'
    EOS

    mkdir "cnf"
    touch "cnf/build.bnd"

    output = shell_output("#{bin}/bnd resolve resolve -b launch.bndrun")
    assert_match(/BUNDLES\s+#{test_bsn};version='\[#{test_version},#{test_version_next}\)'/, output)
  end
end
