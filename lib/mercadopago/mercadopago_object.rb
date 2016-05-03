require 'json'

module MercadoPagoBlack
  class MercadopagoObject
    include Enumerable

    attr_accessor :attrs

    @@list = Array.new

    def initialize
      @attrs = Hash.new
    end

    def self.each

    end

    def to_json(options = nil)
      @attrs.to_json(options)
    end

    def method_missing(method, *args, &block)
      value = @attrs[method[0..-2].to_sym] rescue nil
      @attrs[method[0..-2].to_sym] = args[0] if method[-1] == '=' # Dynamic Assign
      return value if value
    end

    def self.method_missing(method, *args, &block)
      p "lorem"
      return "lorem"
    end

    def self.all
      @@list
    end

    def new

    end

    def create

    end

    def new_from_hash

    end

    def populate_from_rest

    end
  end
end
