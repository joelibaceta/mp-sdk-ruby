require 'active_support/all'

class Hash
  
  def diff(another={})
    result = Hash.new
    another.each do |key, value|
      unless self[key].nil?
        result[key] = value
      end
    end
    return result
  end
  
  def method_missing(name, *args, &blk)
    key = name.to_s
    if self.has_key? key 
      return self[key]  
    end
  end
  
end