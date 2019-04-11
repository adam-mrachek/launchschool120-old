# If we have this code:

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# What happens in the following cases?

# case 1:

# hello = Hello.new
# hello.hi             # "Hello"

# case 2:

# hello = Hello.new
# hello.bye            # undefined method for 'bye'

# case 3:

# hello = Hello.new
# hello.greet          # wrong number of arguments 

# case 4:

# hello = Hello.new
# hello.greet("Goodbye")  # Goodbye

# case 5:

Hello.hi                # undefined method 'hi'