class String
  def to_class
    begin
      Object.const_get(self)
    rescue
      # swallow as we want to return nil
    end
  end
end