require "test_helper"
require "ripper"

class IndexTest < Minitest::Test
  def setup
    doc = <<'__EOD__'
add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    @index = Skippa::Index.parse(sexp)
  end

  def test_table_name
    assert_equal "users", @index.table_name
  end

  def test_column_names
    assert_equal ["email"], @index.column_names
  end

  def test_options
    assert_equal({ "name" => "index_users_on_email", "unique" => "true", "using" => "btree" }, @index.options)
  end
end
