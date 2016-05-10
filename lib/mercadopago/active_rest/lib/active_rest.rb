# @author Joel Ibaceta

require 'json'
require_relative 'active_rest/core/string'
require_relative 'active_rest/rest_client/rest_client'
require_relative 'active_rest/base'


# It allows a Class to behave as a Resource of an API REST
#
# @note Modify this module may alter the correct operation of the Gem
module ActiveREST

  # Its method is called when the module ActiveREST is extended from another Class
  # @param base represents the class which is extended by the module
  def self.extended(base)
    # It create a new class called @@list for persist temporarily as Objects, the API Resources
    base.class_variable_set("@@list", Array.new)
  end

  # When a missing method is called try to call it as an Array method
  def method_missing(method, *args, &block)
    begin
      list = class_variable_get("@@list")
      list.method(method).call # Delegate array methods
    rescue
      #
    end
  end

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

  def has_crud_rest_methods(opts={})

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
  module_function :has_crud_rest_methods



end


