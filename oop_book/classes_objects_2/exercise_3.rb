# When running the following code...

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"
puts bob.name

# We get the following error...

# test.rb:9:in `<main>': undefined method `name=' for
#   #<Person:0x007fef41838a28 @name="Steve"> (NoMethodError)

# Why do we get this error and how to we fix it?

# Answer: There is no setter method for the 'name' instance variable - there is only a getter method.
# Changing attr_reader to attr_accessor will give us the setter method needed to change the variable.