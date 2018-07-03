module Skippa
  class Schema
    # http://api.rubyonrails.org/classes/ActiveRecord/Schema.html#method-c-define

    class << self
      def parse(sexp)
        new(sexp)
      end
    end

    attr_reader :sexp

    def initialize(sexp)
      @sexp = sexp
    end

    def inspect
      "#<#{self.class.inspect}:#{self.object_id.inspect} info=#{self.info.inspect}, extentions=#{self.extentions.inspect}, tables=#{self.tables.inspect}, indexes=#{self.indexes.inspect}>"
    end

    def pretty_print(q)
      q.group(2, "#<#{self.class.inspect}:#{self.object_id.inspect}") do
        q.breakable
        q.text "info="
        q.pp self.info
        q.text ","

        q.breakable
        q.group(2, "extentions=[") do
          self.extentions.each do |extention|
            q.breakable
            q.pp extention
            q.text ","
          end
        end
        q.breakable
        q.text "],"

        q.breakable
        q.group(2, "tables=[") do
          self.tables.each do |table|
            q.breakable
            q.pp table
            q.text ","
          end
        end
        q.breakable
        q.text "],"

        q.breakable
        q.group(2, "indexes=[") do
          self.indexes.each do |index|
            q.breakable
            q.pp index
            q.text ","
          end
        end
        q.breakable
        q.text "],"
      end
      q.breakable
      q.text ">"
    end

    def info
      key_value_array = sexp.dig(1, 2, 1, 1, 0, 1).flat_map do |assoc_new|
        [
          assoc_new.dig(1, 1).chop, # chop `:`
          assoc_new.dig(2, 1)
        ]
      end
      Hash[*key_value_array]
    end

    def extentions
      sexp
        .dig(2, 2, 1)
        .select { |command| command.dig(1, 1) == "enable_extension" rescue false}
        .map { |command| Skippa::Extention.parse(command) }
    end

    def tables
      sexp
        .dig(2, 2, 1)
        .select { |method_add_block| method_add_block.dig(1, 1, 1) == "create_table" rescue false }
        .map { |method_add_block| Skippa::Table.parse(method_add_block) }
    end

    def indexes
      sexp
        .dig(2, 2, 1)
        .select { |method_add_block| method_add_block.dig(1, 1) == "add_index" rescue false }
        .map { |method_add_block| Skippa::Index.parse(method_add_block)}
    end
  end
end
