# In the last question we had a module called Speed which contained a go_fast method. We included this module in the Car class as shown below.

# When we called the go_fast method from an instance of the Car class (as shown below) you might have noticed that the string printed when we go fast includes the name of the type of vehicle we are using. How is this done?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

small_car = Car.new
small_car.go_fast

# Answer:
# When we call #go_fast method on the Car object, Ruby looks for the #go_fast method
# in the Car class first, but since the method is part of the Speed module, Ruby goes up
# the ancestor chain to the Speed module to find the #go_fast method. The method then
# puts the string which includes the #{self.class} interpolation. In the case of our example,
# self.class evaluates to Car because we called the #go_fast method on a Car object.

# Launch School Answer:
#   1. self refers to the object itself, in this case either a Car or Truck object.
#   2. We ask self to tell us its class with .class. It tells us.
#   3. We don't need to use to_s here because it is inside of a string and is interpolated which means it will take care of the to_s for us.