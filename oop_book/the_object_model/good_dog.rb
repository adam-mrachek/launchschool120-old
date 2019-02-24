module Speak
  def speak(sound)
    puts "#{sound}"
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

puts "---GoodDog Ancestors---"
puts GoodDog.ancestors
puts "---HumanBeing Ancestors---"
puts HumanBeing.ancestors