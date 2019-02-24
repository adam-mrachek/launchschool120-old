# A module is a collection of beheviors that can be used by Classes.
# They give Classes additional functionality that doesn't need to be locked into the class - it can be shared across Classes.

module Greeting
  def greeting
    puts "Hello!"
  end
end

class MyClass
  include Greeting
end

new_obj = MyClass.new
new_obj.greeting