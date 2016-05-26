class StrongVariable

  attr_accessor :name
  attr_accessor :type
  attr_accessor :length
  attr_accessor :read_only
  attr_accessor :default
  attr_accessor :default_value
  attr_accessor :valid_values
  attr_accessor :format

  def initialize(*args)
      params = args[0].nil? ? [] : args[0]
      params.each do |k, v|
      begin
        self.instance_variable_set("@#{k}", v)
      rescue => error
        puts "Bad variable initialization #{k} : #{v}"
      end
    end
  end

  def to_hash
    response = Hash.new
    response[:name]         = @name         if @name
    response[:type]         = @type         if @type
    response[:length]       = @length       if @length
    response[:read_only]    = @read_only    if @read_only
    response[:default]      = @default      if @default
    response[:valid_values] = @valid_values if @valid_values
    response[:format]       = format        if @format
    return response
  end

  def friendly_print

  end

  def allow_this?(value)
    value.class == @type
  end

  def try_to_parse_and_format

  end
  
  def name; @name; end

  def type; @type; end

  def format; @format; end

end