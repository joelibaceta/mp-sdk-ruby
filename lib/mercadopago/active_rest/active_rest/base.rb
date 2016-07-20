require 'digest'
require 'time'

module ActiveREST
  
  # Base class used by the classes to adquire the ActiveREST improvements
  #
  class Base
 
    # Hash which manage the attributes for the object
    #
    attr_accessor :attributes

    # When the class is inherited
    #
    def self.inherited(sub_class)
      
      # Extend the Module ActiveREST within the inheriting class
      #
      sub_class.extend(ActiveREST)
      
      # Eval in Class context
      # 
      sub_class.class_eval do 
        
        # Allow to initialize an object from a hash of params
        # overwritting the initialize method
        #
        def initialize(hash_values={})
          hash_values.map{|k, v| set_variable(k,v)} unless hash_values.nil?
          yield self if block_given? # Execute code block if a block was given
        end 
        # Get the object structure
        def self.structure
          structure = self.class_variable_get("@@attr_header").map {|k, v| [k => v.to_h]}
          structure.flatten.reduce({}, :merge)
        end 
        
        # Load and object from a binary file
        def self.load_from_binary_file(file)
          dump_object     = Marshal::load(file)
          dump_object.class.append(dump_object)
          yield dump_object if block_given? 
        end 
      end 
    end
    
    # Get a String with the idempotency fields concatenated
    #
    def idempotency_fields
      class_header_attributes.map { |definition| 
        definition.idempotency_parameter ? self.__send__("#{definition}.name") : nil
      }.compact.join("&")
    end

    # Save a file in to a binary file
    # 
    def binary_dump_in_file(file)
      dump = Marshal::dump(self)
      file.puts(dump)
    end

    # Return a json hash with the object variables information
    #
    def to_json(options = nil)
      response = attributes.map do |k,v|  
        v.class == Array ? {k=> v.map{|item| item} } : {k => v}
      end
      (response.reduce Hash.new, :merge).to_json
    end
    
    # Allow to simplify the access to attributes values like methods
    # Allow to set values to the attributes
    #
    def method_missing(method, *args, &block)
      @attributes = Hash.new if @attributes == nil
      if method[-1] == '='
        set_variable(method[0..-2], args[0])
      else 
        return @attributes[method.to_s]
      end
    end

    # Set an attribute value for an instance
    #
    def set_variable(attribute, value)
      definition = class_header_attributes[attribute.to_sym]
      if (definition != nil) # if there are a definition for the variable
        if definition.allow_this?(value)
          assign_value_to attribute, value
        else 
          new_value = try_to_parse_and_format_with(definition, value) 
          assign_value_to attribute, (new_value || value)
        end
      else
        #if allow_dynamic_attributes
          assign_value_to attribute, value
        #else
        #  raise ARError, "This class does not allow dynamic attributes, 
        #  #{attribute} has not been defined"
        #end
      end
      
    end

    # Update object with a json response informacion
    # 
    def fill_from_response(response)
      response.each{ |attr, v| assign_value_to attr, v } if response 
    end

    # Validates and try to parse the information 
    # to comply with the REST Specification
    #
    def try_to_parse_and_format_with(definition, value)
      begin 
        case definition.type.to_s
          when "Float";   return Float(value)
          when "Integer"; return Integer(value.to_i)
          when "String";  return String(value)
          when "Date";    return Time.parse(value).iso8601
        end
      rescue
        raise ARError,  "Type Error: Can't Parse #{value.class} " \
                        "to #{definition.type} for #{value}"
      end
    end
      
    def assign_value_to(name, value) 
      @attributes       = Hash.new unless @attributes 
      name, value       = build_object(name, value)
      @attributes[name] = value
    end
    
    # Allow to save a new instance in the local collections Only
    #
    def local_save(base=self)
      base.class.append(base)
      yield base if block_given? 
    end

    # Save the object locally and 
    # send a POST request to endpoint to register a remote resource
    #
    def save(base=self) 
      response        = nil 
      uuid            = self.primary_keys_hash
      repeated_object = self.class.find_by_primary_keys_hash(uuid)
      
      # If the object exists previusly
      update(base) if repeated_object != nil
      unless repeated_object != nil
        base.remote_save { |_response| response = _response }  
      end
      
      if block_given?; yield response
      else; return base
      end
    end
    
    # Update a local object and 
    # send a PUT request to the endpoint to update a remote resource 
    # and update the local object again with the response information
    #
    def update(base=self)  
      
      if self.class.update_url 
        response = do_request("update_url", :put) 
        if (["200", "201"].include? response.code.to_s )
          self.fill_from_response(response.body) 
        end
        
      else
        raise ARError, "This class can't be updated remotely, \
                        Check the Resource Definition"
      end
      
      if block_given?; yield response; end
      
    end

    # Save the object locally and 
    # send a POST request to endpoint to register a remote resource
    #
    def remote_save
      local_save(self) 
      if self.class.create_url 
        response = do_request("create_url", :post) 
        if response.code.to_s == "200" || response.code.to_s == "201"
          self.fill_from_response(response.body) 
        end 
        yield response if block_given? 
      else
        raise ARError, "This class can't be saved remotely, \
                        Check the Resource Definition"
      end
    end 
    alias_method :save!, :remote_save
    
    # Remove an object from the local collections
    #
    def destroy 
      list = self.class.class_variable_get("@@list")
      list.each_with_index do |item, index|
        list.delete_at(index) if item.id == self.id
        item.remote_destroy
      end 
    end

    # Remove an object from the local collections and
    # send a DELETE request to endpoint to delate a remote resource
    #
    def remote_destroy
      self.class.prepare_rest_params
      str_url = self.class.remove_url.url
      @attributes.map{ |k,v|  (str_url = str_url.gsub(":#{k}", v.to_s)) }

      if self.class.remove_url
        response = MercadoPago::RESTClient.delete(str_url, url_query: global_rest_params, headers: custom_headers)
        if block_given?
          yield response
        end
      end
    end
    alias_method :remote!, :remote_destroy

    
    def self.prepare_rest_params
      self.prepare_request_stack.map {|isq| isq.call}
    end
    
    def primary_keys_hash
      if self.attributes
        response = self.attributes.map do |k, v|
          begin; 
            is_primary = class_header_attributes[k.to_sym].is_primary_key?
            v if is_primary
            [__id__] unless is_primary
          rescue; nil; end
        end
      else
        response = [__id__]
      end
      Digest::SHA256.hexdigest(response.compact.join) 
    end 

    private
    # Private helpers to made a clean code
    
    # build an object nested structure from a hash
    # 
    def build_object(name, value) 
      klass_name = "MercadoPago::#{name.to_s.singularize.camelize}"
      if (klass_name.to_class) # If is an object or a collection
        if value.class == Array 
          return name.to_s.pluralize, value.map{|item| build_object(name, item)[1]}
        end 
        if value.class == Hash
          begin
            klass = klass_name.to_class
            object = klass.new(value)
            klass.append(object)
            return name.to_s, object
          rescue
            return name.to_s, value
          end
        end 
        return (value.attributes rescue nil) ? [name.to_s, value.attributes] : [name.to_s, value] 
      else
        return name.to_s, value
      end
    end 
    
    
    # Return a unique hash_code which represents the object
    def hash_code; Digest::SHA256.hexdigest(@attributes.values.join); end 
    def custom_headers; self.class.class_variable_get("@@custom_headers"); end
    def class_header_attributes; self.class.class_variable_get("@@attr_header"); end
    def global_rest_params; self.class.class_variable_get("@@global_rest_params"); end 
    def allow_dynamic_attributes; self.class.class_variable_get("@@dynamic_attributes"); end
    
      
    def do_request(url, method)
      self.class.prepare_rest_params
      params  = self.class.create_url.params.merge(global_rest_params)
      headers = self.class.class_variable_get("@@custom_headers")
      str_url = self.class.__send__(url).url
      
      @attributes.map{|k,v| str_url = str_url.gsub(":#{k}", v.to_s)}
      
      response = MercadoPago::RESTClient.__send__(method.to_s, str_url, json_data: self.to_json, url_query: params, headers: headers)
      return response
    end

  end
end
