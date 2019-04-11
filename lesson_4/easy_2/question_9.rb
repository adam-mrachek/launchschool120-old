# If we have this class:

class Game
  def play play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    # rules of play
  end
end

# What would happen if we added a play method to the Bingo class, keeping in mind that there is already a method of this name in the Game class that the Bingo class inherits from.

# Answer:
# When play is called on a Bingo object, Ruby will first look in the Bingo class for the play method.
# When it finds the play method in the Bingo class it will execute that method instead of the Game#play method.