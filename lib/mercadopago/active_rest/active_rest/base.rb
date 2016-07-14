require 'digest'
require 'time'

module ActiveREST
  class Base
 
    attr_accessor :attributes

    def self.inherited(sub_class)
      sub_class.extend(ActiveREST)
      sub_class.class_eval do 
        # Allow to initialize an object from a hash of params
        def initialize(hash_values={})
          hash_values.map{|k, v| set_variable(k,v)} unless hash_values.nil?
          yield self if block_given?
        end 
        # Get the object structure
        def self.structure
          class_header_attributes.map {|k, v| [k => v.to_h]}.flatten
        end 
        # Load and object from a binary file
        def self.load_from_binary_file(file)
          dump_object     = Marshal::load(file)
          dump_object.class.append(dump_object)
          yield dump_object if block_given? 
        end 
      end 
    end

    # Save a file in to a binary file
    def binary_dump_in_file(file)
      dump = Marshal::dump(self)
      file.puts(dump)
    end

    # Return a json hash with the object variables information
    def to_json(options = nil)
      response = attributes.map do |k,v|  
        v.class == Array ? {k=> v.map{|item| item} } : {k => v}
      end
      (response.reduce Hash.new, :merge).to_json
    end
      
    def method_missing(method, *args, &block)
      @attributes = Hash.new if @attributes == nil
      if method[-1] == '='
        set_variable(method[0..-2], args[0])
      else
        return @attributes[method.to_s]
      end
    end

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
        #  raise ARError, "This class does not allow dynamic attributes, #{attribute} has not been defined"
        #end
      end
      
    end

    # Update object with a json response informacion
    def fill_from_response(response)
      response.each do |attr, value|
        assign_value_to attr, value
      end
    end

    def try_to_parse_and_format_with(definition, value)
      begin 
        case definition.type.to_s
          when "Float"
            return Float(value)
          when "Integer"
            return Integer(value.to_i)
          when "String"
            return String(value)
          when "Date" 
            return Time.parse(value).iso8601 
        end
      rescue
        raise ARError,  "Type Error: Can't Parse #{value.class} " \
                        "to #{definition.type} for #{definition.to_hash}"
      end
    end
      
    def assign_value_to(name, value) 
      @attributes = Hash.new unless @attributes 
      name, value = build_object(name, value)
      @attributes[name] = value
    end

    def local_save(base=self)
      base.class.append(base)
      if block_given?
        yield base
      end
    end

    def save(base=self)
      
      response = nil
      
      if (self.class.find_by_primary_keys_hash(self.primary_keys_hash)) # If the object exists previusly
        update(base)
      else
        base.remote_save { |_response| response = _response }  
      end
      
      if block_given?; yield response
      else; return base
      end
    end
    
    def update(base=self)  
      
      if self.class.update_url 
        response = do_request("update_url", :put) 
        if (["200", "201"].include? response.code.to_s )
          self.fill_from_response(response.body) 
        end
        
      else
        raise ARError, "This class can't be updated remotely, Check the Resource Definition"
      end
      
      if block_given?; yield response; end
      
    end

    def remote_save
      local_save(self) 
      if self.class.create_url 
        response = do_request("create_url", :post) 
        if response.code.to_s == "200" || response.code.to_s == "201"
          self.fill_from_response(response.body) 
        end 
        yield response if block_given? 
      else
        raise ARError, "This class can't be saved remotely, Check the Resource Definition"
      end
    end 
    

    def destroy 
      list = self.class.class_variable_get("@@list")
      list.each_with_index do |item, index|
        list.delete_at(index) if item.id == self.id
        item.remote_destroy
      end 
    end

    def remote_destroy
      self.class.prepare_rest_params
      str_url = self.class.remove_url.url
      @attributes.map{ |k,v|  (str_url = str_url.gsub(":#{k}", v.to_s)) }

      if self.class.remove_url
        response = MercadoPago::RESTClient.delete(str_url, url_query: global_rest_params, headers:custom_headers)
        if block_given?
          yield response
        end
      end
    end

    def self.prepare_rest_params
      self.prepare_request_stack.map {|isq| isq.call}
    end

    private
    # Private helpers to made a clean code
    
    def build_object(name, value) 
      klass_name = "MercadoPago::#{name.to_s.singularize.camelize}"
      if (klass_name.to_class) # If is an object or a collection
        if value.class == Array 
          return name.to_s.pluralize, value.map{|item| build_object(name, item)[1]}
        end
        if value.class == Hash
          klass = klass_name.to_class
          object = klass.new(value)
          klass.append(object)
          return name.to_s, object
        end
        
        return (value.attributes rescue nil) ? [name.to_s, value.attributes] : [name.to_s, value] 
      else
        return name.to_s, value
      end
    end 
    
    def primary_keys_hash  
      response = @attributes.map do |k, v|  
        begin; v if class_header_attributes[k.to_sym].is_primary_key?  
        rescue; nil; end 
      end
      Digest::SHA256.hexdigest(response.compact.join) 
    end 
    
    # Return a unique hash_code which represents the object
    def hash_code; Digest::SHA256.hexdigest(@attributes.values.join); end 
    def custom_headers; self.class.class_variable_get("@@custom_headers"); end
    def class_header_attributes; self.class.class_variable_get("@@attr_header"); end
    def global_rest_params; self.class.class_variable_get("@@global_rest_params"); end 
    def allow_dynamic_attributes; self.class.class_variable_get("@@dynamic_attributes"); end
    
    private 
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
