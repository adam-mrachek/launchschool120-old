require 'pry'

module Utilities
  def joinor(arr, delimeter=', ', join_word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then "#{arr.first} #{join_word} #{arr.last}"
    else
      arr[-1] = "#{join_word} #{arr.last}"
      arr.join(delimeter)
    end
  end

  def empty_line
    puts ""
  end

  def clear
    system('clear') || system('cls')
  end

  def horizontal_rule
    puts "---------------------"
  end
end

module Displayable
  def display_welcome_message(game_name, winning_score)
    clear
    empty_line
    puts "Welcome to #{game_name}!"
    empty_line
    puts "*First player to #{winning_score} wins the game!*"
    empty_line
  end

  def display_goodbye_message(game_name)
    puts "Thanks for playing #{game_name}! Goodbye!"
  end

  def display_play_again_message
    puts "Let's play again!"
    empty_line
  end

  def display_choose_name
    horizontal_rule
    puts "Please enter a name:"
    puts "Must be between 1 and 10 characters"
    puts "Numbers and letters only"
    horizontal_rule
  end

  def display_choose_first_player
    puts "Who should go first this game? ('h' for human, 'c' for computer)"
  end

  def display_invalid_name
    puts "Sorry, that's an invalid name."
  end

  def display_invalid_choice
    puts "Sorry, that's not a valid choice."
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  # rubocop: disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won_round?
    !!winning_marker
  end

  # return winning marker or return nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # return at risk square or nil
  def at_risk_square(marker)
    unmarked_square = nil
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if threatened_row?(squares, marker)
        line.each do |square|
          if @squares[square].unmarked?
            unmarked_square = square
          end
        end
      end
    end
    unmarked_square
  end

  def five_square_open?
    @squares[5].unmarked?
  end

  private

  def threatened_row?(squares, player_marker)
    squares.select { |square| square.marker == player_marker }.count == 2 &&
      squares.select(&:unmarked?).size == 1
  end

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3

    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker, :name

  def initialize(marker, name = ' ')
    @marker = marker
    @name = name
  end
end

# orchestration engine

class TTTGame
  include Utilities
  include Displayable

  WINNING_SCORE = 2
  FIRST_TO_MOVE = 'choose'
  GAME_NAME = 'Tic Tac Toe'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @current_marker = FIRST_TO_MOVE
    @human = Player.new('X')
    @computer = Player.new('O')
    @score = { human: 0, computer: 0 }
  end

  def play
    display_welcome_message(GAME_NAME, WINNING_SCORE)
    choose_game_conditions

    loop do
      loop do
        display_board
        player_move_gameplay
        update_score_and_display_result
        break if someone_won_game?

        display_next_round_prompt
        reset_board
      end

      display_game_winner
      break unless play_again?

      reset_game
      display_play_again_message
    end
    display_goodbye_message(GAME_NAME)
  end

  private

  def choose_game_conditions
    choose_player_names
    choose_marker
    set_first_player
  end

  def choose_marker
    puts "Which marker would you like to use? (Enter 'x' for X or 'o' for O)"
    choice = nil
    loop do
      choice = gets.chomp.downcase
      break if %w(x o).include?(choice)

      puts "Invalid choice. Enter 'x' or 'o'."
    end

    case choice
    when 'o'
      human.marker = "O"
      computer.marker = "X"
    end
  end

  def choose_player_names
    choose_human_name
    choose_computer_name
  end

  def choose_human_name
    input = ''
    loop do
      display_choose_name
      input = gets.chomp
      break unless input.empty? || input =~ /[^A-Za-z0-9]/

      display_invalid_name
    end
    human.name = input if !input.empty?
  end

  def choose_computer_name
    computer.name = ['R2D2', 'Number 5', 'C3PO', 'T1000', 'Bender'].sample
  end

  def set_first_player
    if FIRST_TO_MOVE == 'choose'
      choose_first_player
    else
      @current_marker = FIRST_TO_MOVE
    end
  end

  def choose_first_player
    choice = nil
    loop do
      display_choose_first_player
      choice = gets.chomp.downcase
      break if %w(h c).include?(choice)

      display_invalid_choice
    end

    case choice
    when 'c' then @current_marker = computer.marker
    when 'h' then @current_marker = human.marker
    end
  end

  def player_move_gameplay
    loop do
      current_player_moves
      break if board.someone_won_round? || board.full?

      clear_screen_and_display_board if human_turn?
    end
  end

  def display_board
    puts "#{human.name} a #{human.marker}. "\
         "#{computer.name} is a #{computer.marker}."
    empty_line
    board.draw
    empty_line
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    if board.at_risk_square(computer.marker)
      attack_at_risk_square
    elsif board.at_risk_square(human.marker)
      defend_at_risk_square
    elsif board.five_square_open?
      choose_middle_square
    else
      choose_random_square
    end
  end

  def attack_at_risk_square
    board[board.at_risk_square(computer.marker)] = computer.marker
  end

  def defend_at_risk_square
    board[board.at_risk_square(human.marker)] = computer.marker
  end

  def choose_middle_square
    board[5] = computer.marker
  end

  def choose_random_square
    board[board.unmarked_keys.sample] = computer.marker
  end

  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    case board.winning_marker
    when human.marker
      @score[:human] += 1
    when computer.marker
      @score[:computer] += 1
    end
  end

  def update_score_and_display_result
    update_score
    display_result
    display_score
  end

  def someone_won_game?
    @score[:human] == WINNING_SCORE || @score[:computer] == WINNING_SCORE
  end

  def display_game_winner
    if @score[:human] == WINNING_SCORE
      puts "You won the game!"
    elsif @score[:computer] == WINNING_SCORE
      puts "#{computer.name} won the game!"
    end
  end

  def display_score
    horizontal_rule
    puts "SCORE:"
    puts "#{human.name}: #{@score[:human]}"
    puts "#{computer.name}: #{@score[:computer]}"
    horizontal_rule
  end

  def display_next_round_prompt
    puts "Press enter to start next round."
    gets.chomp
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer

      puts "Sorry, you must enter y or n."
    end

    answer == 'y'
  end

  def reset_board
    board.reset
    clear
    set_first_player
  end

  def reset_game
    @score[:human] = 0
    @score[:computer] = 0
    reset_board
  end
end

game = TTTGame.new
game.play
