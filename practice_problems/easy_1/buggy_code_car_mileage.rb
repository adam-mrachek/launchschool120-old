class Car
  attr_accessor :mileage

  def initialize
    @mileage = 0
  end

  def increment_milage(miles)
    total = mileage + miles
    self.mileage = total
  end

  def print_mileage
    puts @mileage
  end
end

car = Car.new
car.mileage = 5000
car.increment_milage(678)
car.print_mileage