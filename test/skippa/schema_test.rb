require "test_helper"
require "ripper"

class SchemaTest < Minitest::Test
  def setup
    doc = <<'__EOD__'
ActiveRecord::Schema.define(version: 20180522032741) do
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "access_log", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "timestamp", limit: 8
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "password", limit: 255, default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
end
__EOD__
    sexp = Ripper.sexp(doc).dig(1, 0)
    @schema = Skippa::Schema.parse(sexp)
  end

  def test_info
    assert_equal({ "version" => "20180522032741" }, @schema.info)
  end

  def test_extentions
    assert_equal ["plpgsql", "hstore"], @schema.extentions.map(&:name)
  end

  def test_tables
    assert_equal ["access_log", "users"], @schema.tables.map(&:name)
  end

  def test_indexes
    assert_equal ["index_users_on_email"], @schema.indexes.map { |index| index.options["name"] }
  end
end
