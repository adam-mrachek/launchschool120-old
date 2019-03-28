# Using the following code, create a class named Cat that prints a greeting when #greet is invoked. The greeting should include the name and color of the cat. Use a constant to define the color.

class Cat
  attr_reader :name
  COLOR = "black"
  def initialize(name)
    @name = name
  end

  def greet
    puts "Hi! My name is #{name} and I'm a #{COLOR} cat."
  end
end

kitty = Cat.new("Sophie")
kitty.greet