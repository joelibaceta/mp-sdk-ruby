# @author Joel Ibaceta

require 'json'
require_relative 'active_rest/core/string'
require_relative 'active_rest/core/hash'
require_relative 'active_rest/rest_client/rest_client'
require_relative 'active_rest/base'
require_relative 'active_rest/ar_error'
require_relative 'active_rest/strong_variable'

require 'active_support/all'

# It allows a Class to behave as a Resource of an API REST
#
# @note Modify this module may alter the correct operation of the Gem
module ActiveREST


  Struct.new("REST_URL", :name, :url, :params)
  # Its method is called when the module ActiveREST is extended from another Class
  # @param base represents the class which is extended by the module
  def self.extended(base)
    base.class_variable_set("@@list", Array.new)
    base.class_variable_set("@@global_rest_params", Hash.new)
    base.class_variable_set("@@prepare_request_stack", Array.new)
    base.class_variable_set("@@attr_header", Hash.new)
    base.class_variable_set("@@dynamic_attributes", true)
    base.class_variable_set("@@dynamic_relations", Hash.new)
  end

  # When a missing method is called try to call it as an Array method
  def method_missing(method, *args, &block)
    _kind, value = kind_of_method(method)
    case _kind
      when "find_by"
        find_by(value, args[0])
      when "array_method"
        resource_collection.__send__(method, *args, &block)
      when "method_for_all"
        all.__send__(method, *args, &block)
      else
        # Do Nothing
    end
  end

  def kind_of_method(method)

    match = /find_by_/.match(method.to_s)

    if match.to_s ==  "find_by_"
      value = match.post_match
      return "find_by", value
    end

    if ["all", "length", "inspect"].include?(method)
      return "array_method", nil
    end

    if ["first", "last"].include?(method.to_s)
      return "method_for_all", nil
    end

    return "unknow", nil
  end


  def prepare_request_stack
    class_variable_get("@@prepare_request_stack")
  end

  def not_allow_dynamic_attributes
    class_variable_set("@@dynamic_attributes", false)
  end
  module_function :not_allow_dynamic_attributes

  def has_strong_attribute(name, *params)
    begin
      definition = attributes_definition
      definition[name] = StrongVariable.new((params[0]))
    rescue => error
      puts "#{error} \n Bad variable definition on #{self}"
    end
  end
  module_function :has_strong_attribute



  def has_relation(relation)
    relation.each do |k, v|
      relations = dynamic_relations
      relations[v]=k
    end
  end
  module_function :has_relation


  # Reset all the objects
  def reset
    class_variable_set("@@list", Array.new)
    populate_from_api
  end


  def populate_from_api(url_params = {}, params = {})

    if self.list_url

      str_url = self.list_url.url
      url_params.map { |k,v| str_url=str_url.gsub(" =>#{k}", v) }

      klass   = self

      self.prepare_rest_params

      params  = self.list_url.params.merge(class_variable_get("@@global_rest_params"))

      response = get(str_url, params, klass)

      response.each do |attrs|
        object = klass.new(attrs)
        klass.append(object)
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


  def load(id, params={})

    self.prepare_rest_params
    params = self.read_url.params.merge(class_variable_get("@@global_rest_params"))

    response = get(self.read_url.url.gsub(":id", id), params, self)

    object = self.new(response)
    self.append(object)
    if block_given?
      yield object
    end
  end

  def find(id)
    return find_by(:id, id)
  end

  def find_by(attribute, value)

    list = class_variable_get("@@list")

    list.each do |item|
      puts "EACH: #{item}"
      if item.__send__(attribute) == value
        return item
      end
    end
    return nil
  end

  def clean
    class_variable_set("@@list", [])
  end

  def refresh

  end

  def append(object)
    list, founded = class_variable_get("@@list"), false
    list.each do |item|
      founded = true if item.id == object.id
    end

    unless founded
      list << object
      class_variable_set("@@list", list)
    end

  end

  def create(hash={})
    object = self.new(hash)
    object.remote_save



    if block_given? 
      yield object
    end
  end

  def all
    populate_from_api if self.list_url
    if block_given?
      yield class_variable_get("@@list")
    end
    return class_variable_get("@@list")
  end

  def before_api_request(&block) 
    stack = class_variable_get("@@prepare_request_stack")
    stack << block 
  end
  module_function :before_api_request

  def set_param(k, v) 
    params_variables = class_variable_get("@@global_rest_params")
    params_variables[k] = v 
  end
  module_function :set_param

  def has_rest_method(opts={})

    reserved_params = [:idempotency]

    action = opts.first

    reserved_params.push(action[0])

    params = opts.except(*reserved_params)

    variable_name = "@@#{action[0]}_url"

    self.class_variable_set(variable_name, Struct::REST_URL.new(action[0], action[1], params))
    self.class_eval("def self.#{action[0]}_url; #{variable_name}; end")
  end
  module_function :has_rest_method

  private #helpers

  def dynamic_relations
    class_variable_get("@@dynamic_relations")
  end

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


