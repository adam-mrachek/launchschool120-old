class Animal
  def initialize(name)
    say_hi
    @name = name
  end
end

class Dog < Animal

  def say_hi
    puts "Hi from the Dog class!"
  end
end

bruce = Dog.new('Bruce')
p bruce