# Fake Operators

One reason Ruby is hard for beginners is due to its liberal syntax. We've already seen from the Equivalence assignment that the "double equals" equality operator, ==, is actually a method and not a real operator. It only looks like an operator because Ruby gives us special syntactical sugar when invoking that method. Instead of calling the method normally (eg. str1.==(str2)), we can call it with a special syntax that reads more naturally (eg. str1 == str2).

This might have triggered the question: what other operators are actually methods being invoked with special syntax? Are all operators, in fact, methods? Below is a table that shows which operators are real operators, and which are methods disguised as operators (listed by order of precedence; highest first).

https://launchschool.com/lessons/d2f05460/assignments/9a7db2ee

The operators marked with a "yes" in the "Method" column means that these operators are in fact methods, which means we can override their functionality. This appears to be a useful feature, but the other side is that since any class can override these fake operators, reading code like this: obj1 + obj2 opens up a world of possibility as to what that can mean. Notice that except assignment and a few other obvious operators, there appears to be a lot of fake operators that we can override! This makes Ruby both powerful and potentially dangerous. Let's explore how to use these fake operators in a sensible way.

# Equality Methods

One of the most common fake operators to be overridden is the `==` equality operator. Since we spend a good amount of time talking about that already, we won't cover it in depth here. Suffice it to say, it's very useful to override this method and doing so also gives us a `!=` method.

# Comparison Methods

Overriding the comparison methods gives us a really nice syntax for comparing objects. 

For example:

```ruby

class Person
  attr_accessor :name, age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

bob = Person.new('Bob', 49)
kim = Person.new('Kim', 33)

puts "bob is older than kim" if bob > kim    # NoMethodError

```

The code above gives a `NoMethodError` because Ruby can't find the `>` method for `bob`. We can fix that by adding a `>` method to the `Person` class.

```ruby

class Person
  attr_accessor :name, age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def >(other_person)
    age > other_person.age
  end
end

bob = Person.new('Bob', 49)
kim = Person.new('Kim', 33)

puts "bob is older" if bob > kim    # 'bob is older'
puts "bob is older" if bob.>(kim)   # 'bob is older'

```

Now, the above implementation will return `true` if the current object's age is greater than the `other_person`'s age, and false otherwise. Notice that we are pushing the comparison functionality to the `Integer#>` method. Now, we can use the `Person#>` method in conditionals.

Note: defining `>` does not automatically give us `<`. We have to define a `<` method in the Person class to get that functionality.

# The << and >> shift methods

Just like any of the other fake operators, you can override `<<` and `>>` do do anything; they are, after all, just regular instance methods. However, it's not common to override `>>` so we don't go into detail explaining it in this assignment.

When overriding fake operators, choose some functionality that makes sience when used with the special operator-like syntax. For example, using the `<<` method fits well when working with a class that represents a collection.

```ruby

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end
end

cowboys = Team.new("Dallas Cowboys")
emmitt = Person.new("Emmitt Smith", 46)

cowboys << emmitt

p cowboys.members    # => [#<Person:0x007fe08c209530>]

```

By implementing `Team#<<`, we provided a very clean interface for adding new members to a team object. If we wanted to be strict, we could even build in a guard clause to reject adding the member unless some criteria is met.

```ruby

def <<(person)
  return if person.not_yet_18?              # suppose we had Person#not_yet_18?
  members.push person
end

```

Adding the shift operators can result in very clean code, but they make the most sense when working with classes that represent a collection.

# The plus method

One of the first examples you'll see in any introduction to programming tutorial is: `1 + 1 = 2`. But even this simple line of code has hidden depth. We're finally able to reveal the hidden secret: that's actually a method call.

```ruby

1 + 1    # 2
1.+(1)   # 2

```

For this reason, Rubyists keep repeating the phrase *everything in Ruby is an object*, and that's true for integers as well. Because integers are objects of the `Integer` class, they have access to the `Integer` instance methods. In the case of `1.+(1)`, the method we're using is `Integer#+`. In ruby, a `Integer` is a specific kind of integer.

Side note: Float is the other kind of number. It is used for floating point precision numbers.

So when should we write a `+` method for our own objects? Let's look at the standard library for some inspiration:
- `Integer#+`: increments the value by value of the argument, returning a new integer.
- `String#+`: concatenates with argument, returning a new string.
- `Array#+`: concatenates with argument, returning new array.
- `Date#+`: increments the date in days by value of the argument, returning a new date.

See the pattern? The functionality of the `+` should be either *incrementing* or *concatenation* with the argument. You are, of course, free to implement it however you wish, but it's probably a good idea to follow the general usage of the standard libraries.

For example: 

```ruby

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end

  def +(other_team)
    members + other_team.members
  end
end

cowboys = Team.new("Dallas Cowboys")
cowboys << Person.new("Troy Aikman", 48)
cowboys << Person.new("Emmitt Smith", 46)
cowboys << Person.new("Michael Irvin", 49)

niners = Team.new("San Francisco 49ers")
niners << Person.new("Joe Montana", 59)
niners << Person.new("Jerry Rice", 52)
niners << Person.new("Deion Sanders", 47)

dream_team = cowboys + niners    # what is dream_team?

```

In this case `Team#+` returns an array of `Person` objects. While this is perfectly valid code, it doesn't match the general pattern we saw in the standard libray. The `Integer#+` method return a new `Integer` object, the `String#+` method return a new `String` objec, and the `Date#+` method returns a new `Date` object. 

To match the pattern used in the standard libary, our `Team#+` method should return a `Team` object. The `Team#initialize` method requires a name which makes it a little awkward so we could do more refactoring to improve it, but that will deviate too much from the main point of this section. So, we'll just initialize the team name to "Temporary Team" for now.

```ruby

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end

  def +(other_team)
    temp_team = Team.new("Temporary Team")
    temp_team.members = members + other_team.members
    temp_team
  end
end

cowboys = Team.new("Dallas Cowboys")
cowboys << Person.new("Troy Aikman", 48)
cowboys << Person.new("Emmitt Smith", 46)
cowboys << Person.new("Michael Irvin", 49)

niners = Team.new("San Francisco 49ers")
niners << Person.new("Joe Montana", 59)
niners << Person.new("Jerry Rice", 52)
niners << Person.new("Deion Sanders", 47)

dream_team = cowboys + niners    # what is dream_team?

```

# Element setter and getter methods

We use element setters and getters a lot, mostly by the way of working with arrays. Out of all of the fake operators, `[]` and `[]=` are probably the most surprising. Part of the reason is because the syntatical sugar given to these methods is so extreme.

```ruby

my_array = %w(first second third fourth)

#element reference
my_array[2]      # "third"
my_array.[](2)   # "third"

```

The above two examples of using `Array#[]` to reference an element are identical, yet they look dramatically different. Ruby gives us a nice syntax to make it read much more naturally.

Ruby goes one step farther for `Array#[]=`.

```ruby

my_array = %w(first second third fourth)

# element assignment
my_array[4] = 'fifth'
puts my_array.inspect      # => ["first", "second", "third", "fourth", "fifth"]

my_array.[]=(5, 'sixth')
puts my_array.inspect      # => ["first", "second", "third", "fourth", "fifth", "sixth"]

```

Again, Ruby gives us a nice syntax that reads much more naturally.

To use the element setter and getter methods in our class, we first have to make sure we're working with a class that represents a collection. Again, these are normal instance methods so we can make them do anything, but let's follow the lead of the Ruby standard library and build them as simple getter(reference) and setter (assignment) methods for elements in our collection.

```ruby

class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end

  def +(other_team)
    temp_team = Team.new("Temporary Team")
    temp_team.members = members + other_team.members
    temp_team
  end

  def [](idx)      # here's our element getter method
    members[idx]
  end

  def []=(idx, obj)  # here's our elemeent setter method
    members[idx] = obj
  end
end

cowboys = Team.new("Dallas Cowboys")
cowboys << Person.new("Troy Aikman", 48)
cowboys << Person.new("Emmitt Smith", 46)
cowboys << Person.new("Michael Irvin", 49)

niners = Team.new("San Francisco 49ers")
niners << Person.new("Joe Montana", 59)
niners << Person.new("Jerry Rice", 52)
niners << Person.new("Deion Sanders", 47)

p cowboys[1]
cowboys[3] = Person.new("JJ", 72)
p cowboys[3]

```

We're taking advantage of the fact that @members is an array, so we can push the real work to the `Array#[]` and `Array#[]=` methods. With our two new methods, we can now do both element reference and assignment using `Team#[]` and `Team#[]=`, respectively. This syntatical sugar adds a new readability aspect to our code.