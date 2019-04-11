# In the following class, which one of the methods is a class method and how do you know?
# How would you call a class method?

class Television
  def self.manufacturer
    #method logic
  end

  def model
    # method logic
  end
end

# Answer:
# The #manufacturer method is the class method because is starts with self.
# You call a class method like this:

Television.manufacturer