# @author Joel Ibaceta

require 'json'
require_relative 'active_rest/core/string'
require_relative 'active_rest/rest_client/rest_client'
require_relative 'active_rest/base'
require_relative 'active_rest/ar_error'
require_relative 'active_rest/strong_variable'

# It allows a Class to behave as a Resource of an API REST
#
# @note Modify this module may alter the correct operation of the Gem
module ActiveREST

  # Its method is called when the module ActiveREST is extended from another Class
  # @param base represents the class which is extended by the module
  def self.extended(base)
    base.class_variable_set("@@list", Array.new)
    base.class_variable_set("@@attr_header", Hash.new)
    base.class_variable_set("@@dynamic_attributes", true)
  end

  # When a missing method is called try to call it as an Array method
  def method_missing(method, *args, &block)
    if dynamic_attributes_allowed?
      resource_collection.__send__(method, *args, &block)
    else
    end
  end

  def not_allow_dynamic_attributes
    class_variable_set("@@dynamic_attributes", false)
  end
  module_function :not_allow_dynamic_attributes

  def has_strong_attribute(name, *params)
    begin
      definition = attributes_definition
      definition[name] = StrongVariable.new(params[0])

    rescue => error
      puts "#{error} \n Bad variable definition on #{self}"
    end
  end
  module_function :has_strong_attribute

  def relation_has_one(name)

  end
  module_function :relation_has_one

  def relation_has_many(name)

  end
  module_function :relation_has_many

  # Reset all the objects
  def reset
    class_variable_set("@@list", Array.new)
    populate_from_api
  end


  def populate_from_api

    if self.list_url #TODO: Token Support
      klass = self
      response = get(self.list_url, {}, self)
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
    list = class_variable_get("@@list")
    list << object
    class_variable_set("@@list", list)
  end

  def all; class_variable_get("@@list"); end

  def has_rest_method(opts={})

    if opts[:list]
      self.class_variable_set("@@list_url", opts[:list])
      self.class_eval("def self.list_url; @@list_url; end")
    end

    if opts[:create]
      self.class_variable_set("@@create_url", opts[:create])
      self.class_eval("def self.create_url; @@create_url; end")
    end

    if opts[:read]
      self.class_variable_set("@@read_url", opts[:read])
      self.class_eval("def self.read_url; @@read_url; end")
    end

    if opts[:update]
      self.class_variable_set("@@update_url", opts[:update])
      self.class_eval("def self.update_url; @@update_url; end")
    end

    if opts[:delete]
      self.class_variable_set("@@delete_url", opts[:delete])
      self.class_eval("def self.delete_url; @@delete_url; end")
    end

  end
  module_function :has_rest_method

  private #helpers

  def resource_collection
    class_variable_get("@@list")
  end

  def attributes_definition
    class_variable_get("@@attr_header")
  end

  def dynamic_attributes_allowed?
    class_variable_get("@@dynamic_attributes")
  end

end


