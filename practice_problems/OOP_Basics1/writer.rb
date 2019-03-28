# Using the code from the previous exercise, add a setter method named #name. Then, rename kitty to 'Luna' and invoke #greet again.

class Cat
  attr_reader :name
  attr_writer :name

  def initialize(name)
    @name = name
  end

  def greet
    "Hello! My name is #{name}!"
  end
end

kitty = Cat.new("Sophie")
puts kitty.greet
kitty.name = "Luna"
puts kitty.greet