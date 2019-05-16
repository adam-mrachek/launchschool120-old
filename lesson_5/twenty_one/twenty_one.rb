require 'pry'

class Player
  attr_accessor :hand

  def initialize(name)
    # what would the 'data' or 'states' of a Player object entail?
    # maybe cards? name?
    @hand = []
    @name = name
  end

  def show_hand
    puts "#{@name} has #{card_values(@hand)} for a total of #{total}."
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

class Card
  def initialize
    # what are the 'states' of a card?
  end
end

class Game
  WINNING_SCORE = 21
  DEALER_STAY = 17

  def initialize
    @game_deck = Deck.new
    @player = Player.new('Adam')
    @dealer = Player.new('Dealer')
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn unless @player.busted?(WINNING_SCORE)
    show_final_cards
    show_result
  end

  def deal_cards
    2.times do
      @player.hand << @game_deck.deal
      @dealer.hand << @game_deck.deal
    end
  end

  def show_initial_cards
    @player.show_hand
    show_dealer_face_up_card
  end

  def show_final_cards
    @player.show_hand
    @dealer.show_hand
  end

  def show_dealer_face_up_card
    puts "Dealer is showing #{@dealer.hand[0][1]}."
  end

  def player_turn
    loop do
      break if @player.busted?(WINNING_SCORE) || @player.stay?

      @player.hit(@game_deck)
      @player.show_hand
    end
  end

  def dealer_turn
    while @dealer.total < DEALER_STAY
      @dealer.hit(@game_deck)
      @dealer.show_hand
      sleep 1.5
    end
  end

  def show_result
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

end

Game.new.start