# What is used in this class but doesn't add any value?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end

# Answer:
# The `return` in the information method is unecessary since Ruby automatically returns the last line of any method.
# Also, the attr_accessor for color and brightness are unused in the class. They could be used in information method.