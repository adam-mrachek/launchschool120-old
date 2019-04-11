# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

  
# What would happen if I called the methods like shown below?

tv = Television.new
tv.manufacturer           # undefined method 'manufacturer'
tv.model                  # the `model` instance method would be executed
  
Television.manufacturer   # the `manufacturer` class method would be executed
Television.model          # undefined method `model`