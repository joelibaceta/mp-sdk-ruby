class Hash
  def method_missing(name, *args, &blk)
    key = name.to_s
    return self[key] if self.has_key? key
    super
  end
end