# What could you add to this class to simplify it and remove two methods from the class
# while still maintaining the same functionality?

class BeesWax
  attr_accessor :type    # add this instead of the getter and setter methods below

  def initialize(type)
    @type = type
  end

  # def type             # move this to the attr_accessor
  #   @type
  # end

  # def type=(t)         # move this to the attr_accessor
  #   @type = t 
  # end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end