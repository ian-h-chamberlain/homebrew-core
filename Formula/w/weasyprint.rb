class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/05/56/4a6733f43a357b99e6bb5e8c8fdb6d817e993367534e83df694dd2bb1604/weasyprint-60.1.tar.gz"
  sha256 "56b9812280118357b0f63b1efe18199e08343d4a56a3393c1d475ab878cea26a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "022e63cfda9893eb9fe9e827e31368febaa8266abc53e79da8c49097c0c7f992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5fa664d605d36a801777f28fb169d5c0bbd1d6c0e7090bd54db2c12256bc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92dfec72820826dabc702f388be7e7d15127252794a25aafc65bea6872257ad0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed4c3770eb0410365967f9ab491a1ee4914627e1aed779780870d2790d35ca24"
    sha256 cellar: :any_skip_relocation, ventura:        "8d7405b72daf828dad2970aaf0a3509379e431ada5057972a1624c5e6d443545"
    sha256 cellar: :any_skip_relocation, monterey:       "be56865a379a7fe162a7d1fb61fed217753864488ad8c5a6bce56de85642e9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b12775c3728f71f78ba7aeb1fc34d0cc2a5b6a8f113adf63522bf80f8e57a31e"
  end

  depends_on "cffi"
  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/18/dc/b607bbc7c15327c5d5ec25681a3707c847906134925d21a26ec6e7416a4a/pydyf-0.8.0.tar.gz"
    sha256 "b22b1ef016141b54941ad66ed4e036a7bdff39c0b360993b283875c3f854dd9a"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/4b/52/46b119f94b3f68e4193ada36941606d8e26852b67bb6e099b0e310540b41/pyphen-0.14.0.tar.gz"
    sha256 "596c8b3be1c1a70411ba5f6517d9ccfe3083c758ae2b94a45f2707346d8e66fa"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/92/d8/71230eb25ede499401a9a39ddf66fab4e4dab149bf75ed2ecea51a662d9e/zopfli-0.2.3.zip"
    sha256 "dbc9841bedd736041eb5e6982cd92da93bee145745f5422f3795f6f258cdc6ef"
  end

  def install
    virtualenv_install_with_resources
    # we depend on fonttools, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    fonttools = Formula["fonttools"].opt_libexec
    (libexec/site_packages/"homebrew-fonttools.pth").write fonttools/site_packages
  end

  test do
    (testpath/"example.html").write <<~EOS
      <p>This is a PDF</p>
    EOS
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_predicate testpath/"example.pdf", :exist?
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
