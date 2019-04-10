# If we have the class below, what would you need to call to create a new instance of the class.

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

Bag.new('brown', 'paper')    # answer