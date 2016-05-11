module ActiveREST

  # It allows a class to have dynamic attributes
  class Base
    extend RESTClient

    attr_accessor :attrs

    def self.inherited(sub_class)
      sub_class.extend(ActiveREST)
      sub_class.include(RESTClient)
    end

    def initialize
      @attrs = Hash.new
    end

    def to_json(options = nil)
      @attrs.to_json(options)
    end

    def method_missing(method, *args, &block)
      value = @attrs[method[0..-2]] rescue nil
      @attrs[method[0..-2]] = args[0] if method[-1] == '=' rescue nil
      return value if value
    end

    def set_variable(k, v)
      @attrs[k] = v rescue @attrs = Hash.new
    end

    def save
      self.class.append(self)
      return post(self.class.create_url, self.to_json, self.class) if self.class.create_url
    end

  end
end