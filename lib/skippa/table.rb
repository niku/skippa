module Skippa
  class Table
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-create_table

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
      "#<#{self.class.inspect}:#{self.object_id.inspect} name=#{self.name.inspect}, comment=#{self.comment.inspect}, options=#{self.options.inspect}, columns=#{self.columns.inspect}>"
    end

    def pretty_print(q)
      q.group(2, "#<#{self.class.inspect}:#{self.object_id.inspect}") do
        q.breakable
        q.text "name="
        q.pp self.name
        q.text ","

        q.breakable
        q.text "comment="
        q.pp self.comment
        q.text ","

        q.breakable
        q.text "options="
        q.pp self.options
        q.text ","

        q.breakable
        q.group(2, "columns=[") do
          self.columns.each do |column|
            q.breakable
            q.pp column
            q.text ","
          end
        end
        q.breakable
        q.text "],"
      end
      q.breakable
      q.text ">"
    end

    def name
      sexp
        .dig(1, 2, 1, 0, 1, 1, 1)
    end

    def comment
      # TODO
    end

    def options
      key_value_array = sexp.dig(1, 2, 1, 1, 1).flat_map do |assoc_new|
        key = assoc_new.dig(1, 1).chop # chop `:`
        value = case v = assoc_new.dig(2, 1)
                when Array
                  case v[0]
                  when :@kw # bool
                    v.dig(1)
                  when :symbol #symbol
                    v.dig(1, 1)
                  when Array # array of string/symbol
                    v.map{|s| s.dig(1, 1, 1)}
                  end
                else
                  v
                end
        [key, value]
      end
      Hash[*key_value_array]
    end

    def columns
      sexp
        .dig(2, 2, 1)
        .map { |command_call| Skippa::Column.parse(command_call) }
    end
  end
end
