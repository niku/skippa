# Skippa

A `schema.rb` parser with using ripper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'skippa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skippa

## Usage

```ruby
~/src/skippa $ bin/console
irb(main):001:0> require "pp"
=> true
irb(main):002:0> doc = <<__EOD__
irb(main):003:0" ActiveRecord::Schema.define(version: 20180522032741) do
irb(main):004:0"   enable_extension "plpgsql"
irb(main):005:0"   enable_extension "hstore"
irb(main):006:0"
irb(main):007:0"   create_table "access_log", id: false, force: :cascade do |t|
irb(main):008:0"     t.integer "user_id"
irb(main):009:0"     t.datetime "timestamp", limit: 8
irb(main):010:0"   end
irb(main):011:0"
irb(main):012:0"   create_table "users", force: :cascade do |t|
irb(main):013:0"     t.string "email", limit: 255, default: "", null: false
irb(main):014:0"     t.string "password", limit: 255, default: "", null: false
irb(main):015:0"   end
irb(main):016:0"
irb(main):017:0"   add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
irb(main):018:0" end
irb(main):019:0" __EOD__
=> "ActiveRecord::Schema.define(version: 20180522032741) do\n  enable_extension \"plpgsql\"\n  enable_extension \"hstore\"\n\n  create_table \"access_log\", id: false, force: :cascade do |t|\n    t.integer \"user_id\"\n    t.datetime \"timestamp\", limit: 8\n  end\n\n  create_table \"users\", force: :cascade do |t|\n    t.string \"email\", limit: 255, default: \"\", null: false\n    t.string \"password\", limit: 255, default: \"\", null: false\n  end\n\n  add_index \"users\", [\"email\"], name: \"index_users_on_email\", unique: true, using: :btree\nend\n"
irb(main):020:0> result = Skippa.parse(doc)
=> #<Skippa::Schema:70233331633100 info={"version"=>"20180522032741"}, extentions=[#<Skippa::Extention:70233331632540 name="plpgsql">, #<Skippa::Extention:70233331632520 name="hstore">], tables=[#<Skippa::Table:70233331631760 name="access_log", comment=nil, options={"id"=>"false", "force"=>"cascade"}, columns=[#<Skippa::Column:70233331631200 name="user_id", type="integer", options={}>, #<Skippa::Column:70233331631180 name="timestamp", type="datetime", options={"limit"=>"8"}>]>, #<Skippa::Table:70233331631740 name="users", comment=nil, options={"force"=>"cascade"}, columns=[#<Skippa::Column:70233331629380 name="email", type="string", options={"limit"=>"255", "default"=>"", "null"=>"false"}>, #<Skippa::Column:70233331629360 name="password", type="string", options={"limit"=>"255", "default"=>"", "null"=>"false"}>]>], indexes=[#<Skippa::Index:70233331627760 table_name="users", column_names=["email"], options={"name"=>"index_users_on_email", "unique"=>"true", "using"=>"btree"}>]>
irb(main):021:0> result.info
=> {"version"=>"20180522032741"}
irb(main):022:0> result.extentions
=> [#<Skippa::Extention:70233331540100 name="plpgsql">, #<Skippa::Extention:70233331540080 name="hstore">]
irb(main):023:0> pp result
#<Skippa::Schema:70233331633100
  info={"version"=>"20180522032741"},
  extentions=[
    #<Skippa::Extention:70233331564400 name="plpgsql">,
    #<Skippa::Extention:70233331564380 name="hstore">,
  ],
  tables=[
    #<Skippa::Table:70233331562600
      name="access_log",
      comment=nil,
      options={"id"=>"false", "force"=>"cascade"},
      columns=[
        #<Skippa::Column:70233331539720
          name="user_id",
          type="integer",
          options={},
        >,
        #<Skippa::Column:70233331539680
          name="timestamp",
          type="datetime",
          options={"limit"=>"8"},
        >,
      ],
    >,
    #<Skippa::Table:70233331562580
      name="users",
      comment=nil,
      options={"force"=>"cascade"},
      columns=[
        #<Skippa::Column:70233331531820
          name="email",
          type="string",
          options={"limit"=>"255", "default"=>"", "null"=>"false"},
        >,
        #<Skippa::Column:70233331531800
          name="password",
          type="string",
          options={"limit"=>"255", "default"=>"", "null"=>"false"},
        >,
      ],
    >,
  ],
  indexes=[
    #<Skippa::Index:70233331487680
      table_name="users",
      column_names=["email"],
      options={"name"=>"index_users_on_email",
       "unique"=>"true",
       "using"=>"btree"},
    >,
  ],
>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/niku/skippa. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Skippa project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/niku/skippa/blob/master/CODE_OF_CONDUCT.md).
