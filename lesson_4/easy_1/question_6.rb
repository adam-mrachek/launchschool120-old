# What could we add to the class below to access the instance variable @volume?

class Cube
  attr_reader :volume    # answer

  def initialize(volume)
    @volume = volume
  end
end

big_cube = Cube.new(5000)
p big_cube.volume
puts big_cube