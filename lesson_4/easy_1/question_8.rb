# If we have a class such as below, you can see in the make_one_year_older method we have used self.
# What does self refer to here?

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# Answer:
# The make_one_year_older method is an instance method and can only be called on instances of the class Cat.
# self refers to the Cat instance (object) calling the make_one_year_older method.