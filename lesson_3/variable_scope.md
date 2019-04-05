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