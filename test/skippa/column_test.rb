require "test_helper"
require "ripper"

class ColumnTest < Minitest::Test
  def setup
    @user_id_column = user_id_column()
    @email_column = email_column()
  end

  def test_name
    assert_equal "user_id", @user_id_column.name
    assert_equal "email", @email_column.name
  end

  def test_type
    assert_equal "integer", @user_id_column.type
    assert_equal "string", @email_column.type
  end

  def test_options
    assert_equal({}, @user_id_column.options)
    assert_equal({ "limit" => "255", "default" => "", "null" => "false", "comment" => "メールアドレス" }, @email_column.options)
  end

  private
  def user_id_column
    doc = <<'__EOD__'
t.integer "user_id"
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    Skippa::Column.parse(sexp)
  end

  def email_column
    doc = <<'__EOD__'
t.string "email", limit: 255, default: "", null: false, comment: "メールアドレス"
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    Skippa::Column.parse(sexp)
  end
end
