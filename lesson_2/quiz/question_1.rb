class Cat
  attr_reader :name
  @@total_cats = 0

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def jump
    "#{name} is jumping!"
  end

  def self.total_cats
    @@total_cats
  end

  def to_s 
    @name
  end
end

mitzi = Cat.new('Mitzi')
p mitzi.jump
p Cat.total_cats
p "The cat's name is #{mitzi}."