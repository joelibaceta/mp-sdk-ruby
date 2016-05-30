class RestError < StandardError
  def initialize(msg=nil)
    @message = msg
    puts @message
  end

  def message
    @message
  end

end