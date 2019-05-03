Twenty-one is a card game consisting of a dealer and a player where participants try to get as close to 21 as possible without going over.

Here is an overview of the game:
- Both participants are initially dealt 2 cards from a 52-card deck.
- The player takes the first turn and can 'hit' or 'stay'.
- If the player busts, he loses. If he stays, it's the dealer's turn.
- The dealer must hit until his cards add up to at least 17.
- If the dealer busts, the player wins. If both player and dealer stays, the the hight total wins.
- If both totals are equal, then it's a tie and nobody wins.

Nouns: card, player, dealer, participant, game, total
Verbs: deal, hit, stay, busts

Total here is not going to be a class, but an attribute within a class. It's not a noun that performs actions, but a property of some other noun. It can also be thought of as a verb: "calculate_total"

Also, the verb "busts" is not an action that anyone performs. Rather, it's a state - is the player/dealer busted?

Let's write out the classes and organize the verbs:

Player
- hit
- stay
- busted?
- total
Dealer
- hit
- stay
- busted?
- total
- deal (should this be here or in Deck?)
Participant
Deck
- deal (should this be here or in Dealer?)
Card
Game
- start

Above we can see that there is a lot of redundancy  in the `Player` and `Dealer` classes and it might make sense to extract the redundancy to a super class or to a module.

# Spike

