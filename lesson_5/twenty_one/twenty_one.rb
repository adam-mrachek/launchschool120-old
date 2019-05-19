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

  def banner
    puts "**********************"
  end
end

module Displayable
  def display_welcome_message
    clear
    puts "Welcome to 21, #{@player.name}!"
    empty_line
    puts "The player with the highest score "\
         "without going over #{TwentyOne::WINNING_SCORE} wins!"
    horizontal_rule
  end

  def display_choose_name
    clear
    horizontal_rule
    puts "Please enter a name:"
    puts "Must be between 1 and 10 characters"
    puts "Numbers and letters only"
    horizontal_rule
  end

  def display_invalid_input
    puts "Sorry, that's an invalid input."
  end

  def display_dealing_cards_message
    puts "Dealing cards..."
    empty_line
    sleep 2.0
  end

  def display_play_again_prompt
    puts "Would you like to play again? (y or n)"
  end

  def display_dealer_turn_message
    puts "#{@player.name} stays. Dealer's turn."
    empty_line
  end

  def display_you_busted_message
    banner
    puts "You busted! Dealer wins!"
    banner
    empty_line
  end

  def display_dealer_busted_message
    banner
    puts "Dealer busted! You win!"
    banner
    empty_line
  end

  def display_participant_hits(name)
    puts "#{name} hits!"
    empty_line
  end

  def display_push_message
    banner
    puts "It's a push!"
    banner
    empty_line
  end

  def display_winner_message(name)
    banner
    puts "#{name} wins the hand!"
    banner
    empty_line
  end

  def display_goodbye_message
    empty_line
    puts "Thanks for playing. Goodbye!"
  end
end

module Hand
  def show_hand
    puts "#{@name}'s hand: "
    @cards.each do |card|
      puts "==> #{card}"
    end
    puts "Total: #{total}"
    empty_line
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
    @cards.each do |card|
      if card.value == 'Ace'
        sum += 11
      elsif card.value.to_i == 0
        sum += 10
      else
        sum += card.value.to_i
      end
    end

    aces = @cards.select { |card| card.value == 'Ace' }

    aces.count.times do
      sum -= 10 if sum > 21
    end

    sum
  end
  # rubocop: enable Style/ConditionalAssignment
end

class Card
  SUITS = ['C', 'S', 'H', 'D']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def value
    case @value
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @value
    end
  end

  def suit
    case @suit
    when 'C' then 'Clubs'
    when 'S' then 'Spades'
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    end
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Participant
  include Hand
  include Displayable
  include Utilities

  attr_accessor :cards, :name

  def initialize
    @cards = []
    @name = set_name
  end

  def hit(deck)
    @cards << deck.deal
  end

  def stay?
    choice = ''
    loop do
      puts "Would you like to (h)it or (s)tay?"
      choice = gets.chomp.downcase
      break if %w(h s).include?(choice)

      display_invalid_input
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
      display_choose_name
      input = gets.chomp
      break unless input.empty? || input =~ /[^A-Za-z0-9]/

      display_invalid_input
    end
    input
  end
end

class Dealer < Participant
  def set_name
    ['R2D2', 'Number 5', 'C3PO', 'T1000', 'Bender'].sample
  end

  def show_face_up_card
    puts "#{@name} is showing #{@cards[0]}."
    empty_line
  end
end

class Deck
  def initialize
    @cards = []
    shuffle_deck
  end

  def shuffle_deck
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @cards << Card.new(value, suit)
      end
    end
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

class TwentyOne
  include Utilities
  include Displayable

  WINNING_SCORE = 21
  DEALER_STAY = 17

  def initialize
    @game_deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def reset
    @game_deck = Deck.new
    @player.cards = []
    @dealer.cards = []
  end

  def start
    display_welcome_message
    loop do
      deal_cards
      display_dealing_cards_message
      show_flop
      player_turn
      dealer_turn unless @player.busted?
      sleep 1.0
      show_final_cards
      show_result
      break unless play_again?

      reset
      clear
    end
    display_goodbye_message
  end

  def deal_cards
    2.times do
      @player.cards << @game_deck.deal
      @dealer.cards << @game_deck.deal
    end
  end

  def show_flop
    @player.show_hand
    @dealer.show_face_up_card
  end

  def show_final_cards
    clear
    @player.show_hand
    @dealer.show_hand
  end

  def player_turn
    loop do
      break if @player.busted? || @player.stay?

      clear
      display_participant_hits(@player.name)
      @player.hit(@game_deck)
      sleep 1.5
      @player.show_hand
      @dealer.show_face_up_card
    end
  end

  def dealer_turn
    clear
    display_dealer_turn_message
    @dealer.show_hand
    while @dealer.total < DEALER_STAY
      sleep 1.0
      display_participant_hits(@dealer.name)
      empty_line
      @dealer.hit(@game_deck)
      sleep 1.5
      @dealer.show_hand
    end
  end

  def show_result
    if @player.busted?
      display_you_busted_message
    elsif @dealer.busted?
      display_dealer_busted_message
    elsif @player.total == @dealer.total
      display_push_message
    elsif @player.total > @dealer.total
      display_winner_message(@player.name)
    else
      display_winner_message(@dealer.name)
    end
  end

  def play_again?
    answer = ""
    loop do
      display_play_again_prompt
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)

      display_invalid_choice
    end
    answer == 'y'
  end
end

TwentyOne.new.start
