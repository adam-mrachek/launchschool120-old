# How could you change the method name below so that the method name is more clear and less repetitive.

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.light_information
    "I want to turn on the light with a brightness level of super high and a colour of green"
  end
end

# Answer:
# Rename `light_information` as just `information`
# This way, calling the method looks like this: `Light.information` instead of `Light.light_information` which is redundant.