module Mammal
  def self. some_out_of_place_method(num) # modules are also used as method containers to house methods that may be out of place within your code.
    num ** 2
  end

  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end
end

buddy = Mammal::Dog.new
kitty = Mammal::Cat.new
buddy.speak("Arf!")
kitty.say_name('kitty')
value = Mammal.some_out_of_place_method(4) # This is how you call methods from the module.
p value
p buddy
p kitty