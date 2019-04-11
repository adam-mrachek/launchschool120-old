# In the class below, explain what @@cats_count variable does and how it works.
# What code would you need to write to test your theory?

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# Answer:
# @@cats_count is a class variable that keeps track of the number of Cat objects created.
# Everytime a new instance of Cat is created, @@cats_count is incremented by 1.
# The code to test the theory is:

paws = Cat.new('tabby')
george = Cat.new('siamese')
p Cat.cats_count             # 2 which is the number of Cat objects we created.