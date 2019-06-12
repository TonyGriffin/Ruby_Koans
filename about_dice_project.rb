require File.expand_path(File.dirname(__FILE__) + '/neo')

# Implement a DiceSet Class here:

class DiceSet

  attr_accessor :values

  @values = []

  def roll(numOfDice)
    @values = (1..numOfDice).map { rand(6) + 1 }

    # numOfDice.downto(1) { |i|
    #   @values.push(1 + rand(6))
    # }

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # From the number of dice thrown/rolled(numOfDice) down to 1.
    # For each of those elements in the values array, generate a random number between 0 upto but not including 6, then add 1... giving a range of 1-6.
    # This value is then added to that element of the array.
  end
end

class AboutDiceProject < Neo::Koan
  def test_can_create_a_dice_set
    dice = DiceSet.new
    assert_not_nil dice
  end

  def test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6
    dice = DiceSet.new

    dice.roll(5)
    assert dice.values.is_a?(Array), "should be an array"
    assert_equal 5, dice.values.size
    dice.values.each do |value|
      assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
    end
  end

  def test_dice_values_do_not_change_unless_explicitly_rolled
    dice = DiceSet.new
    dice.roll(5)
    first_time = dice.values
    second_time = dice.values
    assert_equal first_time, second_time
  end

  def test_dice_values_should_change_between_rolls
    dice = DiceSet.new

    dice.roll(5)
    first_time = dice.values

    dice.roll(5)
    second_time = dice.values

    assert_not_equal first_time, second_time,
      "Two rolls should not be equal"

    # THINK ABOUT IT:
    #
    # If the rolls are random, then it is possible (although not
    # likely) that two consecutive rolls are equal.  What would be a
    # better way to test this?

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    # assert_not_equal [first_time, first_time.object_id],
    # [second_time, second_time.object_id], "Two rolls should not be equal"

    # Not my idea but found it on Stackoverflow and seems to make sense!

  end

  def test_you_can_roll_different_numbers_of_dice
    dice = DiceSet.new

    dice.roll(3)
    assert_equal 3, dice.values.size

    dice.roll(1)
    assert_equal 1, dice.values.size
  end

end
