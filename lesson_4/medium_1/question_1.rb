# Ben asked Alyssa to code review the following code:

class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    @balance >= 0
  end
end

# Alyssa glanced over the code quickly and said - "It looks fine, except that you forgot to put the @ before balance when you refer to the balance instance variable in the body of the positive_balance? method."

# "Not so fast", Ben replied. "What I'm doing here is valid - I'm not missing an @!"

# Who is right, Ben or Alyssa, and why?

# Answer:
# Technically, they're both right since both approaches will work. Ben's code is using the getter method (attr_reader) for balance to retrieve the value. 
# Alyssa's suggestion to use the @ symbol before balance is also valid, but directly accesses the balance variable.

my_account = BankAccount.new(1000)
p my_account.positive_balance?
