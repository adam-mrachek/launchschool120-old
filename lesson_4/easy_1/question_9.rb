# If we have the class such as the one below, in the name of the cats_count method we have used self.
# What does self refer to in this context?

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# Answer:
# Methods defined in a class that start with self are class methods and can only be called by the class itself.
# So, self in this context is referring to the class itself, Cat. So you can call Cats.cats_count.
