# Which of these two classes has an instance variable and how do you know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Answer: The Pizza class has an instance variable, @name. Instance variables start with the @ symbol.
# The Fruit class does not have an instance variable, only a local variable, name.

hot_pizza = Pizza.new("cheese")
orange = Fruit.new("apple")

p hot_pizza.instance_variables
p orange.instance_variables