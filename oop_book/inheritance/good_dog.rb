class Animal
  attr_accessor :name
  def initialize(name)
    @name = name
  end

  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :name

  def initialize(color)
    super
    @color = color
  end

  def speak
    super + " from the GoodDog class"
  end
end

class BadDog < Animal
  def initialize(age, name)
    super(name)
    @age = age
  end
end

class Cat < Animal
end

bruno = BadDog.new(3, 'Boss')
p bruno