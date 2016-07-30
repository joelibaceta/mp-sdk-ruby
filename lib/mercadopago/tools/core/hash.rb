require 'active_support/all'

class Hash
  
  def diff(another={})
    result = Hash.new
    another.each do |key, value|
      result[key] = value unless self[key].nil? 
    end
    return result
  end
  
  def method_missing(name, *args, &blk) 
    return self[name.to_s]    if self.has_key?(name.to_s)  
    return self[name.to_sym]  if self.has_key?(name.to_sym) 
  end
  
end