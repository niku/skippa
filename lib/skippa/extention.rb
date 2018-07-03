module Skippa
  class Extention
    # http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/AbstractAdapter.html#method-i-enable_extension

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
      "#<#{self.class.inspect}:#{self.object_id.inspect} name=#{self.name.inspect}>"
    end

    def name
      sexp
        .dig(2, 1, 0, 1, 1, 1)
    end
  end
end
