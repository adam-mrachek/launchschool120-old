# If we have these two classes:

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

#  and

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# What is the difference in the way the code works?

# Answer:
# There is no difference in the result - only in the way the code in each example accomplishes the task.
# The `show_template` method works in both examples because `show_template` invokes the getter method `template` which does not require `self` (unlike the setter method)
# Therefore, the `self` is not needed in the second example.
# While both `show_template` methods are technically fine, the Ruby style guide is to `Avoid self where not required`.
