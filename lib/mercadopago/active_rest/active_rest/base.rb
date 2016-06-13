module ActiveREST
  class Base
    extend MercadoPago::RESTClient

    attr_accessor :attributes

    def self.inherited(sub_class)
      sub_class.extend(ActiveREST)
      sub_class.include(MercadoPago::RESTClient)
      
      sub_class.class_eval do

        def initialize(hash={})
          hash.map{|k, v| set_variable(k,v)}
          (yield self) if block_given?
        end

        def self.structure
          class_header_attributes.map {|k, v|
            [k=> v.to_h]
          }.flatten
        end

        def self.load_from_binary_file(file)
          dump_object = Marshal::load(file)
          dump_object.class.append(dump_object)
          if block_given?
            yield dump_object
          end
        end

      end

    end
    
    

    def binary_dump_in_file(file)
      dump = Marshal::dump(self)
      file.puts(dump)
    end
    
    def to_json(options = nil);  
      response = attributes.map do |k,v|  
        if v.class == Array 
          {k=> v.map{|item| item}.flatten}
        else
          {k => v}
        end
      end
      (response.reduce Hash.new, :merge).to_json
    end
    
    def attributes; @attributes; end

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
        if (definition.allow_this? value)
          assign_value_to attribute, value
        else 
          new_value = try_to_parse_and_format_with(definition, value) 
          assign_value_to attribute, (new_value || value)
        end
      else
        if true #allow_dynamic_attributes
          assign_value_to attribute, value
        else
          raise ARError, "This class does not allow dynamic attributes, #{attribute} has not been defined"
        end
      end
      
    end


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
            #when "Date"
            #date = Date.parse(value)
            #date = date.strftime(definition.format) if definition.format
            #return date 
        end
      rescue
        raise ARError,  "Type Error: Can't Parse #{value.class} "\
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
      base.remote_save do |response|
        base.fill_from_response(response)
      end

      if block_given?
        yield base
      else
        return base
      end
    end

    def remote_save
      local_save(self)
      self.class.prepare_rest_params

      if self.class.create_url
        p "params"
        p self.class.create_url
        params  = self.class.create_url.params.merge(global_rest_params)
        headers = self.class.class_variable_get("@@custom_headers")
        str_url = self.class.create_url.url

        @attributes.map{ |k,v| str_url = str_url.gsub(":#{k}", v.to_s) }

        response = post(str_url, self.to_json, params, headers, self.class)
        self.fill_from_response(response)
        if block_given?
          yield response
        end
      else
        raise ARError, "This class can't save remotely, Check the Resource Definition"
      end
    end

    def destroy 
      list = self.class.class_variable_get("@@list")
      list.each_with_index do |item, index|
        list.delete_at(index) if item.id == self.id
        item.remote_destroy
      end
      if block_given?
        yield response
      end
    end

    def remote_destroy
      self.class.prepare_rest_params
      str_url = self.class.destroy_url.url
      @attributes.map{ |k,v|
        (str_url = str_url.gsub(":#{k}", v.to_s))
      }

      if self.class.destroy_url
        response = delete(str_url, global_rest_params, custom_headers, self.class)
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
        if (value.attributes rescue nil)
          return name.to_s, value.attributes
        else
          return name.to_s, value
        end
      else
        return name.to_s, value
      end
    end

    def custom_headers
      self.class.class_variable_get("@@custom_headers")
    end

    def global_rest_params
      self.class.class_variable_get("@@global_rest_params")
    end
    
    def class_header_attributes
      self.class.class_variable_get("@@attr_header")
    end

    def allow_dynamic_attributes
      self.class.class_variable_get("@@dynamic_attributes")
    end
    

  end
end
