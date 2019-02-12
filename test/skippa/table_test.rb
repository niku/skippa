require "test_helper"
require "ripper"

class TableTest < Minitest::Test
  def setup
    @access_log_table = access_log_table()
    @users_table = users_table()
    @composite_pkey_table = composite_pkey_table()
  end

  def test_name
    assert_equal "access_log", @access_log_table.name
    assert_equal "users", @users_table.name
    assert_equal "composite_pkey", @composite_pkey_table.name
  end

  def test_options
    assert_equal({ "id" => "false", "force" => "cascade" }, @access_log_table.options)
    assert_equal({ "force" => "cascade" }, @users_table.options)
    assert_equal({ "id" => "false", "force" => "cascade", "primary_key" => ["pkey1", "pkey2"] }, @composite_pkey_table.options)
  end

  def test_columns
    assert_equal ["user_id", "timestamp"], @access_log_table.columns.map(&:name)
    assert_equal ["email", "password"], @users_table.columns.map(&:name)
    assert_equal ["pkey1", "pkey2", "timestamp"], @composite_pkey_table.columns.map(&:name)
  end

  private
  def access_log_table
    doc = <<'__EOD__'
create_table "access_log", id: false, force: :cascade do |t|
  t.integer "user_id"
  t.datetime "timestamp", limit: 8
end
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    Skippa::Table.parse(sexp)
  end

  def users_table
    doc = <<'__EOD__'
create_table "users", force: :cascade do |t|
  t.string "email", limit: 255, default: "", null: false
  t.string "password", limit: 255, default: "", null: false
end
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    Skippa::Table.parse(sexp)
  end
  
  def composite_pkey_table
    doc = <<'__EOD__'
create_table "composite_pkey", id: false, force: :cascade, primary_key: [:pkey1, :pkey2] do |t|
  t.string "pkey1"
  t.integer "pkey2"
  t.datetime "timestamp", limit: 8
end
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    Skippa::Table.parse(sexp)
  end
end
