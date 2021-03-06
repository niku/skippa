require "test_helper"
require "ripper"

class SkippaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Skippa::VERSION
  end

  def test_it_does_something_useful
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
    assert_equal Skippa::Schema, Skippa.parse(doc).class
    assert_equal "20180522032741", Skippa.parse(doc).info["version"]
  end
end
