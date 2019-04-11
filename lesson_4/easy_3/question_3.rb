# When objects are created they are a separate realizations of a particular class.
# Given the class below, how do we create two different instances of this class, both with separate names and ages.

class AngryCat
  def initialize(age, name)
    @age = age
    @name = name 
  end

  def age
    puts @age 
  end

  def name
    puts @name 
  end

  def hiss
    puts "Hissss!!!"
  end
end

# Answer:

garfield = AngryCat.new(7, 'Garfield')
paws = AngryCat.new(10, 'Paws')