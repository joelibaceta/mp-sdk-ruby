# @author Joel Ibaceta

Dir["#{File.dirname(__FILE__)}/active_rest/**/*.rb"].each { |f| load f }

# It allows a Class to behave as a Resource of an API REST
#
# @note Modify this module may alter the correct operation of the Gem
module ActiveREST

  # Struct for saving REST methods params
  Struct.new("REST_URL", :name, :url, :params)

  RESERVED_PARAMS = [:idempotency] # Params with reserved word name
  CIPHER          = lambda {|alg, msg| Object.const_get("Digest::#{alg}").__send__(hexdigest, msg)} # Cipher Method
  
  include MercadoPago::RESTClient

  # This method is called when the module ActiveREST is extended from another Class
  #
  # == Parameters:
  # base:: This param represents to the class which extending the ActiveREST Module
  #
  def self.extended(base)
    base.class_variable_set("@@idempotency_algorithm",  "SHA256"  ) # Algorithm used for Idempotency
    base.class_variable_set("@@list",                   Array.new ) # Objects Collection
    base.class_variable_set("@@prepare_request_stack",  Array.new ) # Pre-Request Procedures Stack
    base.class_variable_set("@@attr_header",            Hash.new  ) # Attributes Definition
    base.class_variable_set("@@global_rest_params",     Hash.new  ) # Defaulta Parameters for REST requests
    base.class_variable_set("@@custom_headers",         Hash.new  ) # Custome Headers for REST requests
    base.class_variable_set("@@dynamic_attributes",     true      ) # If allow dynamic attributes
  end

  # This method allow to define a strong attribute for a class
  #
  # @param [String] name Is the attribute name, should be defined like a symbol
  # @param [Hash] params Is a Hash which contains the additional definition params
  #
  # @option params [String] :type Strong Type Used [String | Integer | Date]
  # @option params [Integer] :length Maximum length for the value
  # @option params [True/False] :read_only If the value is read only
  # @option params [True/False] :default Set a default value to replace a nil value
  # @option params [True/False] :idempotency_parameter
  # @option params [Date] :format
  #
  def has_strong_attribute(name, *params)
    begin
      definition        = attributes_definition
      definition[name]  = StrongVariable.new(params[0])
    rescue => error
      warn "#{error.message} \n Wrong variable definition on #{self}"
    end
  end
  module_function :has_strong_attribute

  # Load resources from api rest list method
  #
  def populate_from_api(url_values = {}) 
    if self.list_url
      self.prepare_rest_params # Run the stacked blocks
      klass     = self
      str_url   = replace_url_variables(self.list_url.url, url_values) 
      response  = get(str_url, url_query: url_params(self.list_url), headers:custom_headers).body
       
      response.map { |attrs| klass.append(klass.new(attrs)) }
    end
  end
  
  # This is a helper method which allow to build a nested objects structure from a hashmap
  #
  def build_object(klass, attrs)
    object = klass.new
    attrs.each { |k, v|
      if k.to_s.to_class # If a key is a Class
        name  = klass.to_s.pluralize
        value = build_object(k.to_class, v)
        object.set_variable(name, value)
      else
        object.set_variable(k, v.to_s)
      end
    }
    return object
  end

  # Append a Class to Objects Collection
  #
  def append(object)
    
    founded = false 
    res_coll.each{|item| (founded = true) if item.primary_keys_hash == object.primary_keys_hash }
    
    if founded
      item   = object.class.find_by_primary_keys_hash(object.primary_keys_hash)
      object.attributes.each { |k,v| item.__send__("#{k}=", v) }
      object = item
    else
      res_coll << object 
    end
    
    return object
  end

  # Create an Object Remotely is equal to use ( new + save ) methods
  #
  def create(hash={})
    begin
      object = self.new(hash)
      object.remote_save
      
      if object
        yield  object if block_given?
        return object unless block_given?
      else; return nil; end
    rescue => error
      raise ARError, "Can't create a #{self} object, " \
                     "an unespected error has been raised: \n " \
                     "#{error.backtrace}"
    end
  end
  
  # Get and object from a REST request using a GET method
  #
  def load(url_values = {})
    
    unless self.read_url.nil?
      self.prepare_rest_params
      str_url   = replace_url_variables(self.read_url.url, url_values)
      response  = get(str_url, url_query: url_params(self.read_url), headers: custom_headers).body
      
      object = self.append(self.new(response))

      if block_given?
        yield object
      else
        return object
      end
    else
      raise ARError, "The class #{self.class} doesn't has a read method"
    end
    
  end
  

  def find(id); return find_by(:id, id); end

  # Find and object in collection by an specific attribute
  #
  def find_by(attribute, value)
    res_coll.each do |item|
      return item if item.__send__(attribute) == value
    end
    return nil
  end

  # Get all the local objects
  #
  def all(opts={only_local: false})
    (populate_from_api if self.list_url) unless opts[:only_local]
    if block_given?; yield class_variable_get("@@list"); end
    return class_variable_get("@@list")
  end

  #
  def before_api_request(&block); prepare_request_stack << block; end
  module_function :before_api_request

  #
  def set_param(k, v)
    global_rest_params[k] = v
  end
  module_function :set_param

  #
  def set_custom_header(k, v); custom_headers[k] = v; end
  module_function :set_custom_header

  #
  def has_rest_method(opts={})
    action          = opts.first
    reserved_params = RESERVED_PARAMS.clone
    reserved_params.push(action[0])
    params          = opts.except(*reserved_params)
    url_struct      = Struct::REST_URL.new(action[0], action[1], params)

    self.class_variable_set("@@#{action[0]}_url", url_struct)
    self.class_eval("def self.#{action[0]}_url; @@#{action[0]}_url; end")

    opts.diff(params).each do |param, value|
      case param.to_s
        when "idempotency"
          (prepare_request_stack << Proc.new {
            set_custom_header("x-idempotency-key", CIPHER.call(idem_alg, idempotency_fields))
          }) if value
      end
    end
  end
  module_function :has_rest_method

  

  # When a method_missing method is called try to call it as an Array method
  def method_missing(method, *args, &block)
    _kind, value = kind_of_method(method)
    case _kind
      when "find_by";         find_by(value, args[0])
      when "array_method";    res_coll.__send__(method, *args, &block)
      when "method_for_all";  all.__send__(method, *args, &block)
      else # Do Nothing
    end
  end

  # Try to classify a method to get a valid response
  def kind_of_method(method)
    match = /find_by_/.match(method.to_s)
    return ["find_by", match.post_match]  if match.to_s ==  "find_by_"
    return ["array_method",         nil]  if ["all", "length", "inspect"].include?(method.to_s)
    return ["method_for_all",       nil]  if ["first", "last"].include?(method.to_s)
    return ["unknow",               nil]
  end

  def clear
    class_variable_set("@@list", Array.new)
  end
  
  def syncronize
    
  end

  # Public Accesors
  #
  def prepare_request_stack
    class_variable_get("@@prepare_request_stack")
  end


  private #helpers

  def set_idempotency_algorithm(algorithm)
    class_variable_set("@@idempotency_algorithm", algorithm)
  end
  module_function :set_idempotency_algorithm

  def idem_alg
    class_variable_get("@@idempotency_algorithm")
  end

  def not_allow_dynamic_attributes
    class_variable_set("@@dynamic_attributes", false)
  end
  module_function :not_allow_dynamic_attributes

  # Clear the objects collection

  def res_coll
    class_variable_get("@@list")
  end

  def attributes_definition
    class_variable_get("@@attr_header")
  end

  def global_rest_params
    class_variable_get("@@global_rest_params")
  end
  
  def url_params(uri)
    uri.params.merge(global_rest_params)
  end

  def dynamic_attributes_allowed?
    class_variable_get("@@dynamic_attributes")
  end

  def custom_headers
    class_variable_get("@@custom_headers")
  end

  def replace_url_variables(url, values={}) 
    _url = url
    values.map {|k,v| _url = _url.gsub(":#{k}", v)}
    return _url
  end

end


