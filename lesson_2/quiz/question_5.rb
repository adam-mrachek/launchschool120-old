class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

class Thief < Character
  def speak
    "#{@name} is whispering..."
  end
end

sneak = Thief.new("Sneak")
p sneak.name
p sneak.speak