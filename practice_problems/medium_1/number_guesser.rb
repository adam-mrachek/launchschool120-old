class GuessingGame

  def initialize(low_value, high_value)
    @low_value = low_value
    @high_value = high_value
    @number = nil
    @guesses = nil
    @range = (@low_value..@high_value)
  end

  def size_of_range
    @high_value - @low_value
  end

  def number_of_guesses
    Math.log2(size_of_range).to_i + 1
  end

  def set_number_and_guesses
    @guesses = number_of_guesses
    @number = rand(@range)
  end

  def play
    set_number_and_guesses
    input = nil
    loop do
      display_guesses_remaining
      input = get_guess
      break if input == @number || @guesses == 0

      display_guess_too_high if input > @number
      display_guess_too_low if input < @number

      @guesses -= 1
    end
    display_result(input)
  end

  def display_guesses_remaining
    puts ""
    if @guesses == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{@guesses} guesses remaining."
    end
  end

  def display_guess_number
    puts "Enter a number between #{@low_value} and #{@high_value}:"
  end

  def get_guess
    loop do
      display_guess_number
      guess = gets.chomp.to_i
      return guess if valid_guess?(guess)

      display_invalid_guess
    end
  end

  def valid_guess?(input)
    @range.cover?(input)
  end

  def display_invalid_guess
    puts "Invalid Guess. #{display_guess_number}"
  end

  def display_guess_too_high
    puts "Your guess is too high."
  end

  def display_guess_too_low
    puts "Your guess is too low."
  end

  def display_result(input)
    if input == @number
      puts "That's the number!"
      puts ""
      puts "You won!"
    else
      puts "You ran out of guesses."
    end
  end
end

game = GuessingGame.new(501, 1500)
game.play
game.play