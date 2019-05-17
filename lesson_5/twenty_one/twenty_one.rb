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

class Player
  attr_accessor :hand

  def initialize(name)
    @hand = []
    @name = name
  end

  def show_hand
    puts "#{@name}'s hand: #{card_values(@hand)} for a total of #{total}."
  end

  def show_face_up_card
    puts "Dealer is showing #{@hand[0][1]}."
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

  def busted?(winning_score)
    total > winning_score
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

class Game
  include Utilities

  WINNING_SCORE = 21
  DEALER_STAY = 17

  def initialize
    shuffle_deck_clear_hands
  end

  def shuffle_deck_clear_hands
    @game_deck = Deck.new
    @player = Player.new('Adam')
    @dealer = Player.new('Dealer')
  end

  def start
    welcome
    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless @player.busted?(WINNING_SCORE)
      sleep 1.0
      show_result
      show_final_cards
      break unless play_again?

      shuffle_deck_clear_hands
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

  def show_initial_cards
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
      break if @player.busted?(WINNING_SCORE) || @player.stay?

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
    if @player.busted?(WINNING_SCORE)
      puts "You busted! Dealer wins!"
    elsif @dealer.busted?(WINNING_SCORE)
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

Game.new.start
