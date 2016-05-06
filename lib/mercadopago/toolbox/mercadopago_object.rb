require 'json'

module MercadopagoObject
  def self.included(base)
    base.instance_variable_set("@attrs", Hash.new)
    base.extend(ClassMethods)
  end

  def to_json(options = nil)
    self.instance_variable_get("@attrs").to_json(options)
  end

  def method_missing(method, *args, &block)
    attrs = instance_variable_get("@attrs")
    value = attrs[method[0..-2].to_sym] rescue nil
    eval_sentence = "@attrs[\"#{method[0..-2]}\".to_sym] = \"#{args[0]}\""
    self.instance_eval(eval_sentence) if method[-1] == '=' rescue nil
    return value if value
  end

  def set_variable(attribute, value)
      self.instance_variable_set("@attrs", Hash.new) unless self.instance_variable_get("@attrs")
      attrs = self.instance_variable_get("@attrs")
      attrs[attribute] = value
      self.instance_variable_set("@attrs", attrs)
  end

  def save
    self.class.append(self)
    if self.class.create_url
      uri = URI(MercadoPagoBlack::Settings.base_url + self.create_url)
      req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
      req.body = self.to_json
    end
  end

  module ClassMethods
    def self.extended(base)
      base.class_variable_set("@@list", Array.new)
    end

    def method_missing(method, *args, &block)
      begin
        list = self.class_variable_get("@@list")
        list.method(method).call # Delegate array methods
      rescue
        #
      end
    end

    def populate_from_api

      if self.list_url
        klass = self
        uri = URI(MercadoPagoBlack::Settings.base_url + self.list_url)
        response = JSON.parse(Net::HTTP.get(uri))
        response.each do |attrs|
          object = build_object(klass, attrs)
          append(object)
        end
      end
    end

    def build_object(klass, attrs)
      object = klass.new
      attrs.each do |k, v|
        if k.to_s.to_class
          value = build_object(k.to_class, v)
          object.set_variable(klass.to_s.pluralize, value)
        else
          object.set_variable(k, v.to_s)
        end
      end
      return object
    end



    def append(object)
      list = self.class_variable_get("@@list")
      list << object
      self.class_variable_set("@@list", list)
    end

    def all; self.class_variable_get("@@list"); end



    def act_as_api_resource(opts={})
      if opts[:list_url]
        self.class_variable_set("@@list_url", opts[:list_url])
        self.class_eval("def self.list_url; @@list_url; end")
      end

      if opts[:create_url]
        self.class_variable_set("@@create_url", opts[:create_url])
        self.class_eval("def self.create_url; @@create_url; end")
      end

      if opts[:read_url]
        self.class_variable_set("@@read_url", opts[:read_url])
        self.class_eval("def self.read_url; @@read_url; end")
      end

      if opts[:update_url]
        self.class_variable_set("@@update_url", opts[:update_url])
        self.class_eval("def self.update_url; @@update_url; end")
      end

      if opts[:delete_url]
        self.class_variable_set("@@delete_url", opts[:delete_url])
        self.class_eval("def self.delete_url; @@delete_url; end")
      end

    end

  end
end