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
    squares.select{|square| square.marker == player_marker}.count == 2 && squares.select(&:unmarked?).size == 1
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
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

# orchestration engine

class TTTGame
  include Utilities

  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER
  WINNING_SCORE = 5

  attr_reader :board, :human, :computer
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
    @score = { human: 0, computer: 0 }
  end

  def play
    clear
    display_welcome_message
    set_first_player

    loop do

      loop do
        display_board

        loop do
          current_player_moves
          break if board.someone_won_round? || board.full?

          clear_screen_and_display_board if human_turn?
        end

        display_result
        update_score
        display_score
        break if someone_won_game?
        start_next_round_prompt

        reset_board
      end
      
      display_game_winner
      break unless play_again?

      reset_game
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def clear
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "First player to #{WINNING_SCORE} wins the game!"
    puts ""
  end

  def set_first_player
    if FIRST_TO_MOVE == 'choose'
      choose_first_player
    else
      current_marker = FIRST_TO_MOVE
    end
  end

  def choose_first_player
    puts "Who should go first this game? ('h' for human, 'c' for computer)"
    choice = nil
    loop do
      choice = gets.chomp.downcase
      break if %w(h c).include?(choice)

      puts "Sorry, that's not a choice. Please enter 'c' or 'h'."
    end

    case choice
    when 'c' then current_marker = COMPUTER_MARKER
    when 'h' then current_marker = HUMAN_MARKER
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
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
    if board.at_risk_square(COMPUTER_MARKER)
      board[board.at_risk_square(COMPUTER_MARKER)] = computer.marker
    elsif board.at_risk_square(HUMAN_MARKER)
      board[board.at_risk_square(HUMAN_MARKER)] = computer.marker
    elsif board.five_square_open?
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
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

  def someone_won_game?
    @score[:human] == WINNING_SCORE || @score[:computer] == WINNING_SCORE
  end

  def display_game_winner
    if @score[:human] == WINNING_SCORE
      puts "You won the game!"
    elsif @score[:computer] == WINNING_SCORE
      puts "Computer won the game!"
    end
  end

  def display_score
    puts "Score: You: #{@score[:human]}, Computer: #{@score[:computer]}"
  end

  def start_next_round_prompt
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
    @current_marker = FIRST_TO_MOVE
  end

  def reset_game
    @score[:human] = 0
    @score[:computer] = 0
    reset_board
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

# game is started like this
game = TTTGame.new
game.play
