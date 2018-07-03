module Skippa
  class Column
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column

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
      "#<#{self.class.inspect}:#{self.object_id.inspect} name=#{self.name.inspect}, type=#{self.type.inspect}, options=#{self.options.inspect}>"
    end

    def pretty_print(q)
      q.group(2, "#<#{self.class.inspect}:#{self.object_id.inspect}") do
        q.breakable
        q.text "name="
        q.pp self.name
        q.text ","

        q.breakable
        q.text "type="
        q.pp self.type
        q.text ","

        q.breakable
        q.text "options="
        q.pp self.options
        q.text ","
      end
      q.breakable
      q.text(">")
    end

    def name
      sexp
        .dig(4, 1, 0, 1, 1, 1)
    end

    def type
      sexp
        .dig(3, 1)
    end

    def options
      key_value_array = Array(sexp.dig(4, 1, 1, 1)).flat_map do |assoc_new|
        key = assoc_new.dig(1, 1).chop # chop `:`
        value = case v = assoc_new.dig(2, 1)
                when [:string_content]
                  # empty string
                  ""
                when Array
                  # symbol or string
                  case v2 = v.dig(1)
                  when Array
                    v2.dig(1)
                  else
                    v2
                  end
                else
                  v
                end
        [key, value]
      end
      Hash[*key_value_array]
    end
  end
end
