require "test_helper"
require "ripper"

class ExtentionTest < Minitest::Test
  def setup
    doc = <<'__EOD__'
enable_extension "plpgsql"
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    @extention = Skippa::Extention.parse(sexp)
  end

  def test_name
    assert_equal "plpgsql", @extention.name
  end
end
