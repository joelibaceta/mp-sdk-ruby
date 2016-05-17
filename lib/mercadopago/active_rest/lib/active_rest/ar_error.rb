class ARError < StandardError
  def initialize(msg=nil)
    @message = msg
    puts @message.red
  end

  def message
    @message
  end

end