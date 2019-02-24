class MyCar
  attr_accessor :color
  attr_reader :year
  attr_reader :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def accelerate(number)
    @speed += number
  end

  def brake(number)
    @speed -= number
  end

  def turn_off
    @speed = 0
    puts "Parking!"
  end

  def current_speed
    puts "You are going #{@speed} mph."
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon."
  end

  def to_s
    "My car is a #{color} #{year} #{model}."
  end
end

my_car = MyCar.new("2018", "Gunmetal", "Tesla P100D")
puts my_car