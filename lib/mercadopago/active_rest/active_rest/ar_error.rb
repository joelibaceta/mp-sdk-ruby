# Custom error class

class ARError < StandardError
  def initialize(msg=nil)
    @message = msg
    warn @message
  end

  def message
    @message
  end

end