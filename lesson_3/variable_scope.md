# Instance Variable Scope

Instance variables are variables that start with @ and are scoped at the *object* level.

They are used to track individual object state and don't cross over between objects.

For example, we can use a `@name` variable to separate the state of `Person` objects:

```ruby

class Person
  def initialize(n)
    @name = n
  end
end

puts bob.inspect    # => #<Person:0x007f9c830e5f70 @name="bob">
puts joe.inspect    # => #<Person:0x007f9c830e5f20 @name="joe">

```

Because the scope of instance variables is at the object level, this means that the instance variable is accessible in an object's instance, even it it's initialized outside of that instance method.

```ruby

class Person
  def initialize(n)
    @name = n
  end

  def get_name
    @name                # the @name instance variable is accessible here
  end
end

bob = Person.new('bob')
bob.get_name            # => "bob"

```

# Class Variable Scope 

Class variables start with `@@` and are scoped at the class level. The exhibit two behaviors:
- all objects share 1 copy of the class variable.
  - (this also implies objects can access class variables by way of instance methods)
- class methods can access class variables, regardless of where it's initialized.

Example:

```ruby

class Person
  @@total_people = 0      # initialized at the class level

  def self.total_people   # accessible from class method
    @@total_people
  end

  def initialize          # mutable from instance method
    @@total_people += 1
  end

  def total_people        # accessible from instance method
    @@total_people
  end
end

Person.total_people             # => 0
Person.new
Person.new
Person.total_people             # => 2

bob = Person.new
bob.total_people                # => 3

joe = Person.new
joe.total_people                # => 4

Person.total_people             # => 4


```

The above demonstrates that even when there are two different `Person` objects in `bob` and `joe`, we're effectively accessing and modifying one copy of the `@@total_people` class variable. We can't do this with instance variables or local variables; only class variables can share state between objects. (ignoring globals here)

# Constant Variable Scope

Constant variables are usually called constants because you're not supposed to re-assign them to a different value. If you *do* re-assign a constant, ruby will warn you (but won't generate an error). Constants being with a capital letter and have *lexical* scope.

Example:

```ruby

class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  attr_reader :name

  def self.titles
    TITLES.join(', ')
  end

  def initialize(n)
    @name = "#{TITLES.sample} #{n}"
  end
end

Person.titles                   # => "Mr, Mrs, Ms, Dr"

bob = Person.new('bob')
bob.name                        # => "Ms bob"  (output may vary)

```

This shows that, within one class, the rules for accessing constants is pretty straightforward; it's available in class methods or instance methods (which implies it's accessible from objects). Where constant resolution gets really tricky is when inheritance is involved, and that's when we need to remember that unlike other variables, constants have lexical scope.