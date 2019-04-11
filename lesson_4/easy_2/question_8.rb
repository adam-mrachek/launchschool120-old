# If we have the following class:

class Game
  def play
    "Start the game!"
  end
end

# And another class...

class Bingo < Game    # answer
  def rules_of_play
    # rules_of_play
  end
end

# What can we add to the Bingo class to allow it to inherit the play method from the Game class?
# Answer:
# We let the Bingo class inherit from the Game class with the `< Game` syntax after the Bingo class name.