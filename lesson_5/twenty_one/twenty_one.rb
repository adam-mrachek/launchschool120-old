require 'pry'
module Utilities
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

module Hand
  def show_hand
    puts "#{@name}'s hand: #{card_values(@hand)} for a total of #{total}."
  end

  # rubocop: disable Style/ConditionalAssignment
  def card_values(hand)
    cards = ""
    hand.each do |card|
      if cards.empty?
        cards << card[1]
      else
        cards << ", #{card[1]}"
      end
    end
    cards
  end
  # rubocop: enable Style/ConditionalAssignment

  # rubocop: disable Style/ConditionalAssignment
  def total
    sum = 0
    values = @hand.map { |card| card[1] }
    values.each do |value|
      if value == 'A'
        sum += 11
      elsif value.to_i == 0
        sum += 10
      else
        sum += value.to_i
      end
    end

    values.count('A').times do
      sum -= 10 if sum > 21
    end

    sum
  end
  # rubocop: enable Style/ConditionalAssignment
end

class Participant
  include Hand

  attr_accessor :hand

  def initialize
    @hand = []
    @name = set_name
  end

  def hit(deck)
    @hand << deck.deal
  end

  def stay?
    choice = ''
    loop do
      puts "Would you like to (h)it or (s)tay?"
      choice = gets.chomp.downcase
      break if %w(h s).include?(choice)

      puts "Sorry, invalid choice."
    end
    choice == 's'
  end

  def busted?
    total > TwentyOne::WINNING_SCORE
  end
end

class Player < Participant
  def set_name
    input = ''
    loop do
      puts "What's your name?"
      input = gets.chomp
      break unless input.empty? || input =~ /[^A-Za-z0-9]/

      puts "Sorry, that's not a valid name."
    end
    input
  end
end

class Dealer < Participant
  def set_name
    ['R2D2', 'Number 5', 'C3PO', 'T1000', 'Bender'].sample
  end

  def show_face_up_card
    puts "#{@name} is showing #{@hand[0][1]}."
  end
end

class Deck
  DECK = [
    ['H', '2'], ['D', '2'], ['C', '2'], ['S', '2'],
    ['H', '3'], ['D', '3'], ['C', '3'], ['S', '3'],
    ['H', '4'], ['D', '4'], ['C', '4'], ['S', '4'],
    ['H', '5'], ['D', '5'], ['C', '5'], ['S', '5'],
    ['H', '6'], ['D', '6'], ['C', '6'], ['S', '6'],
    ['H', '7'], ['D', '7'], ['C', '7'], ['S', '7'],
    ['H', '8'], ['D', '8'], ['C', '8'], ['S', '8'],
    ['H', '9'], ['D', '9'], ['C', '9'], ['S', '9'],
    ['H', '10'], ['D', '10'], ['C', '10'], ['S', '10'],
    ['H', 'J'], ['D', 'J'], ['C', 'J'], ['S', 'J'],
    ['H', 'Q'], ['D', 'Q'], ['C', 'Q'], ['S', 'Q'],
    ['H', 'K'], ['D', 'K'], ['C', 'K'], ['S', 'K'],
    ['H', 'A'], ['D', 'A'], ['C', 'A'], ['S', 'A']
  ]

  def initialize
    @game_deck = DECK.shuffle
  end

  def deal
    @game_deck.pop
  end
end

class TwentyOne
  include Utilities

  WINNING_SCORE = 21
  DEALER_STAY = 17

  def initialize
    @game_deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    @game_deck = Deck.new
    @player.hand = []
    @dealer.hand = []
  end

  def start
    welcome
    loop do
      deal_cards
      show_flop
      player_turn
      dealer_turn unless @player.busted?
      sleep 1.0
      show_result
      show_final_cards
      break unless play_again?

      reset
      clear
    end
  end

  def welcome
    clear
    puts "Welcome to 21!"
    puts "The player with the highest score "\
         "without going over #{WINNING_SCORE} wins!"
    horizontal_rule
  end

  def deal_cards
    2.times do
      @player.hand << @game_deck.deal
      @dealer.hand << @game_deck.deal
    end
  end

  def show_flop
    @player.show_hand
    @dealer.show_face_up_card
  end

  def show_final_cards
    @player.show_hand
    @dealer.show_hand
    horizontal_rule
  end

  def player_turn
    loop do
      break if @player.busted? || @player.stay?

      @player.hit(@game_deck)
      @player.show_hand
    end
  end

  def dealer_turn
    @dealer.show_hand
    while @dealer.total < DEALER_STAY
      sleep 1.0
      empty_line
      puts "**Dealer hits**"
      empty_line
      @dealer.hit(@game_deck)
      sleep 1.5
      @dealer.show_hand
    end
  end

  def show_result
    horizontal_rule
    if @player.busted?
      puts "You busted! Dealer wins!"
    elsif @dealer.busted?
      puts "Dealer busted! You win!"
    elsif @player.total == @dealer.total
      puts "It's a push!"
    elsif @player.total > @dealer.total
      puts "You win!"
    else
      puts "Dealer wins!"
    end
  end

  def play_again?
    answer = ""
    loop do
      puts "Would you like to play again? (y or n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)

      puts "Sorry, invalid choice."
    end
    answer == 'y'
  end
end

TwentyOne.new.start
