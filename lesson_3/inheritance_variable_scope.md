# Instance Variables

How does inheritance and sub-classing affect instance variables?

```ruby

class Animal
  def initialize(name)
    @name = name
  end
end

class Dog < Animal
  def dog_name
    "bark! bark! #{@name} bark! bark!"    # can @name be referenced here?
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name                       # => bark! bark! Teddy bark! bark!

```

Yes! When `teddy` was instantiated, it called `Dog.new`. Since `Dog` doesn't have an initialize instance method, the method lookup path went to the super class, `Animal`, and executed `Animal#initialize`. That's when the `@name` instance variable was initialized, and that's why we can access it from `teddy.dog_name`.

# Instance Variables and Modules

```ruby

module Swim
  def enable_swimming
    @can_swim = true
  end
end

class Dog
  include Swim

  def swim 
    "swimming!" if @can_swim
  end
end

teddy = Dog.new
p teddy.swim            # nil
teddy.enable_swimming
p teddy.swim            # swimming!

```

The first time we called `teddy.swim`, we didn't call `Swim#enable_swimming` so the `@can_swim` instance variable was never initialized. We then call `teddy.enable_swimming` which initializes the `@can_swim` variable which makes it available the second time we call `teddy.swim`.

**_Remember that uninitialized instance variables return `nil`._**

# Class Variables 

Here are some experiments with class variables.

```ruby

class Animal
  @@total_animals = 0

  def initialize
    @@total_animals += 1
  end
end

class Dog < Animal
  def total_animals
    @@total_animals
  end
end

spike = Dog.new
p spike.total_animals    # 1

```

As we can see, class variables are accessible to sub-classes. Since this class variable is initialized in the `Animal` class, there is no method to explicitly invoke to initialize it. The class variable is loaded when the class is evaluated by Ruby.

However, it's important to note that it can be dangerous to work with class variables in the context of inheritance because there is only one copy of the class variable across all sub-classes.

For example,

```ruby

class Vehicle
  @@wheels = 4

  def self.wheels
    @@wheels
  end
end

Vehicle.wheels                              # => 4

class Motorcycle < Vehicle
  @@wheels = 2
end

Motorcycle.wheels                           # => 2
Vehicle.wheels                              # => 2  Yikes!

class Car < Vehicle
end

Car.wheels                                  # => 2  Not what we expected!

```

When only considering the `Vehicle` class alone, the use of the `@@wheels` class variable looks pretty straightforward: we initialized a class variable and expose a class method to return the value of the class variable.

But then we created a sub-class, `Motorcycle` that overrides the `@@wheels` class variable to 2 which will affect all other sub-classes of `Vehicle` such as `Car` where we would expect `@@wheels` to be `4`. The fact that an entirely different sub-class of `Vehicle` can modify this class variable throws a wrench into the way we think about class inheritance.

**_For this reason, avoid using class variables when working with inheritance. In fact, some Rubyists would go as far as recommending avoiding class variables altogether. The solution is usually to use *class instance variables*._** (Class instance variables will be covered later)

# Constants

From previous lessons, we know that constants can be accessed from instance or class methods when defined within a class. But can we reference a constant defined in a different class?

```ruby

class Dog
  LEGS = 4
end

class Cat
  def legs
    LEGS
  end
end

kitty = Cat.new
kitty.legs                                  # => NameError: uninitialized constant Cat::LEGS

```

We get the `NameError` because Ruby is looking for `LEGS` within the `Cat` class. This is expected since this is the same behavior as class or instance variables (except, referencing an unitialized instance variable will return `nil`).

However, unlike class or instance variables, we can reach into the `Dog` class and reference `LEGS` constant. To do so, we have to tell Ruby where the `LEGS` constant is using `::`, which is the namespace resolution operator.

```ruby

class Dog
  LEGS = 4
end

class Cat
  def legs
    Dog::LEGS      # added the :: namespace resolution operator.
  end
end

kitty = Cat.new
kitty.legs         # 4

```

Sidenote: you can use `::` on classes, modules, and constants (namespacing will be covered more later)

So, the above shows how constans behave in two unconnected classes. Let's look at how constants work with inheritance and behave in a sub-class

```ruby

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  def self.wheels
    WHEELS
  end

  def wheels
    WHEELS
  end
end

Car.wheels                                  # => 4

a_car = Car.new
a_car.wheels                                # => 4

```

That looks like pretty familiar behavior - a constant is initialized in a super-class and is inherited by the sub-class. It can be accessed by both class and instance methods.

But what happens when we mix in modules? Let's say we have a module that we want to mix into different vehicles.

```ruby

module Maintenance
  def change_tires
    "Changing #{WHEELS} tires."
  end
end

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  include Maintenance
end

a_car = Car.new
a_car.change_tires                  # => NameError: uninitialized constant Maintenance::WHEELS

```

Unlike instance methods or instance variables, constants are *not* evaluated at runtime, so their lexical scope - or, where they are used in the code - is very important. In this case, the line `Changing #{WHEELS} tires."` is in the `Maintenance` module, which is where Ruby will look for `WHEELS`. Even though we call the `change_tires` method from the `a_car` object, Ruby is not able to find the constant.

Here are two potential fixes:

```ruby 

module Maintenance
  def change_tires
    "Changing #{Vehicle::WHEELS} tires."    # this fix works
  end
end

module Maintenance
  def change_tires
    "Changing #{Car::WHEELS} tires."        # surprisingly, this also works
  end
end

```

Constant resolution will look at lexical scope first, and then look at the inheritance hierarchy. It can get tricky when there are nested modules, each setting the same constants to different values. Be mindful that constant resolution rules area different from method lookup path or instance variables.

# Summary

- _Instance Variables_ behave mostly the way we'd expect. The only thing to watch out for is to make sure the instance variable is initialized before referencing it.
- _Class Variables_ have a very insidious behavior or allowing sub-classes to override super-class class variables. Further, the change will affect all other sub-classes of the super-class. This is extremely unintuitive behavior, forcing some Rubyists to eschew using class variables altogether.
- _Constants_ have lexical scope which makes their scope resolution rules very unique compared to other variable types. If Ruby doesn't find the constant using lexical scope, it'll then look at the inheritance hierarchy.