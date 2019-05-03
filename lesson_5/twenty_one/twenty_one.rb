require 'pry'

class Player
  attr_accessor :hand

  def initialize
    # what would the 'data' or 'states' of a Player object entail?
    # maybe cards? name?
    @hand = []
  end

  def hit

  end

  def stay

  end

  def busted?

  end

  def total
    # definitely look like we need to know about 'cards' to produce some total
  end
end

class Dealer
  attr_accessor :hand

  def initialize
    # seems very similar to Player...do we even need this?
    @hand = []
  end

  def hit

  end

  def stay

  end

  def busted?

  end

  def total
    # definitely look like we need to know about 'cards' to produce some total
  end
end

class Participant
  # what goes in here? all of the redundant behaviors from Player and Dealer?
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
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
    @game_deck = DECK.shuffle
  end

  def deal(hand)
    hand << @game_deck.pop
  end
end

class Card
  def initialize
    # what are the 'states' of a card?
  end
end

class Game
  def initialize
    @game_deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_cards
    # show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
  end

  def deal_cards
    2.times do
      @game_deck.deal(@player.hand)
      @game_deck.deal(@dealer.hand)
    end
    binding.pry
  end
end

Game.new.start