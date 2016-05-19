module ActiveREST
  class Base
    extend RESTClient

    attr_accessor :attributes

    def self.inherited(sub_class)
      sub_class.extend(ActiveREST)
      sub_class.include(RESTClient)
      sub_class.class_eval do

        def initialize(hash={})
          hash.map{|k, v| set_variable(k,v)}
        end

        def self.structure
          class_variable_get("@@attr_header").map {|k, v| ["#{k}": v.to_hash]}.flatten
        end

        # def self.friendly_print_structure
       #    msg="\n"
       #    msg += "#{self} \n".light_green
       #    msg += " | \n".yellow
       #    msg += " ├─ Variables \n".yellow
       #    class_variable_get("@@attr_header").each do |key, attr_hash|
       #      msg += " | ".yellow + (" ├─ " + key.to_s + " : \n").green
       #      msg += " | ".yellow + " │".green + "  └── "
       #      msg += attr_hash.to_hash.map{ |k, v|  " #{k.to_s}".light_white  + " : #{v.to_s}".ljust(20) }.join(" \n | ".yellow + " │".green + "  └── ")
       #      msg += "\n"
       #    end
       #    #msg += " ├─ Nested Models \n".yellow
       #    return msg
       #
       #  end
       #
        def self.friendly_print_structure
          msg="\n"
          msg += "#{self} \n"  
          msg += " | \n"  
          msg += " ├─ Variables \n" 
          msg += " | \n" 
          class_variable_get("@@attr_header").each do |key, attr_hash|
            msg += " | " + (" + " + key.to_s + "  ").ljust(30, '.')  
            msg += attr_hash.to_hash.map{ |k, v|  (" #{k.to_s}:"  + "#{v.to_s}").ljust(30, '.') }.join("")
            msg += " \n" 
          end
          #msg += " ├─ Nested Models \n".yellow
          return msg

        end
      end
    end



    def to_json(options = nil)   
      @attributes.to_json(options)
    end

    def attributes
      @attributes
    end

    def method_missing(method, *args, &block) 
        @attributes = Hash.new if @attributes == nil

      #if method[0..-2] != ""
        method[-1] == '=' ? set_variable(method[0..-2], args[0]) : (return @attributes[method.to_s])
      # else
      #   raise ARError, "This class does not allow dynamic attributes, this attribute has not been defined"
      #end

    end

    def set_variable(attribute, value)
      
      definition = class_header_attributes[attribute.to_sym]
      
      is_an_association = class_relations[attribute] 
       
       

        if (definition != nil) # if there are a definition for the variable
          if (definition.allow_this? value)
            assign_value_to attribute, value
          else 
            new_value = try_to_parse_and_format_with(definition, value) 
            assign_value_to attribute, (new_value || value)
          end
        else
          if allow_dynamic_attributes
            assign_value_to attribute, value
          else
            raise ARError, "This class does not allow dynamic attributes, #{attribute} has not been defined"
          end
        end
     
      
      
      
    end

    def try_to_parse_and_format_with(definition, value)
      begin 
        case definition.type.to_s
          when "Float"
            return Float(value)
          when "Integer"
            return Integer(value)
          when "String"
            return String(value)
          when "Date"
            date = Date.parse(value)
            date = date.strftime(definition.format) if definition.format
            return date 
        end
      rescue
        raise ARError, "Type Error: Can't Parse #{value} to #{definition.type}"
      end
    end


    def assign_value_to(name, value) 
      @attributes = Hash.new unless @attributes
      @attributes[name] = value 
    end

    def local_save(base=self)
      base.class.append(base)
    end

    def remote_save
      local_save(self)
      if self.class.create_url
        response = post(self.class.create_url, self.to_json, self.class)
        if block_given?
          yield response
        end
      else
        raise ARError, "This class can't save remotely, Check the Resource Definition"
      end

    end

    def destroy

    end

    def remote_destroy

    end

    private
    # Private helpers to made a clean code
    def class_header_attributes
      self.class.class_variable_get("@@attr_header")
    end

    def allow_dynamic_attributes
      self.class.class_variable_get("@@dynamic_attributes")
    end
    
    def class_relations
      self.class.class_variable_get("@@dynamic_relations")
    end
  end
end
