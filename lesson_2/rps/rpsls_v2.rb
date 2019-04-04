class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock', 'r', 'p', 'sc',
            'l', 'sp']

  def initialize(value)
    @value = value
  end
end

class Rock < Move
  def win?(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end

  def to_s
    'Rock'
  end
end

class Paper < Move
  def win?(other_move)
    other_move.class == Rock || other_move.class == Spock
  end

  def to_s
    'Paper'
  end
end

class Scissors < Move
  def win?(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end

  def to_s
    'Scissors'
  end
end

class Lizard < Move
  def win?(other_move)
    other_move.class == Spock || other_move.class == Paper
  end

  def to_s
    'Lizard'
  end
end

class Spock < Move
  def win?(other_move)
    other_move.class == Scissors || other_move.class == Rock
  end

  def to_s
    'Spock'
  end
end

class Player
  attr_accessor :move, :name, :score, :move_history

  def initialize
    set_name
    @score = 0
    @move_history = []
  end

  def assign_move(choice)
    case choice
    when 'rock', 'r' then Rock.new('rock')
    when 'paper', 'p' then Paper.new('paper')
    when 'scissors', 'sc' then Scissors.new('scissors')
    when 'lizard', 'l' then Lizard.new('lizard')
    when 'spock', 'sp' then Spock.new('spock')
    end
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?

      puts "Sorry, you must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts ""
      puts "Please choose (r)ock, (p)aper, (sc)issors, (l)izard, or (sp)ock."
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)

      puts "Sorry, invalid choice"
    end
    self.move = assign_move(choice)
    move_history << move
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = assign_move(Move::VALUES.sample)
    move_history << move
  end
end

class RPSGame
  attr_accessor :human, :computer

  WINNING_SCORE = 10

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Hi, #{human.name}. Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts ""
    puts "The first player to win #{WINNING_SCORE} rounds wins the game!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Goodbye!"
  end

  def display_moves
    puts "----------------------------------"
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    puts "----------------------------------"
  end

  def display_round_winner
    if human.move.win?(computer.move)
      puts ""
      puts "*** #{human.name} won! ***"
    elsif computer.move.win?(human.move)
      puts ""
      puts "*** #{computer.name} won! ***"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if human.move.win?(computer.move)
      human.score += 1
    elsif computer.move.win?(human.move)
      computer.score += 1
    end
  end

  def display_score
    puts ""
    puts "SCORE:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts ""
  end

  def game_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_game_winner
    if human.score == WINNING_SCORE
      puts "#{human.name} wins the game!"
    elsif computer.score == WINNING_SCORE
      puts "#{computer.name} wins the game!"
    end
  end

  def play_again?
    choice = nil
    loop do
      puts "Would you like to play again? (y/n)"
      choice = gets.chomp.downcase
      break if ['y', 'n'].include?(choice)

      puts "Sorry, must be y or n."
    end
    choice == 'y'
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def game_ops
    human.choose
    computer.choose
    sleep 0.5
    display_moves
    sleep 0.75
    display_round_winner
    update_score
    display_score
  end

  def play
    system('clear') || system('cls')
    display_welcome_message
    sleep 1.0
    loop do
      reset_score

      loop do
        game_ops
        break if game_winner?
        puts "Press enter to start next round."
        gets
        system('clear') || system('cls')
      end
      display_game_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
