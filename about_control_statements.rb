require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutControlStatements < Neo::Koan

  def test_if_then_else_statements
    if true
      result = :true_value
    else
      result = :false_value
    end
    assert_equal :true_value, result
  end

  def test_if_then_statements
    result = :default_value
    if true
      result = :true_value
    end
    assert_equal :true_value, result
  end

  def test_if_statements_return_values
    value = if true
              :true_value
            else
              :false_value
            end
    assert_equal :true_value, value

    value = if false
              :true_value
            else
              :false_value
            end
    assert_equal :false_value, value

    # NOTE: Actually, EVERY statement in Ruby will return a value, not
    # just if statements.
  end

  def test_if_statements_with_no_else_with_false_condition_return_value
    value = if false
              :true_value
            end
    assert_equal nil, value
  end

  def test_condition_operators
    assert_equal :true_value, (true ? :true_value : :false_value)
    assert_equal :false_value, (false ? :true_value : :false_value)
  end

  def test_if_statement_modifiers
    result = :default_value
    result = :true_value if true

    assert_equal :true_value, result
  end

  # The unless keyword is just an if statement but in reverse so it 
  # executes only if the condition is false. The following are great 
  # resources and some helpful rules when and when not to use the 
  # unless keyword.
  # 
  # Some rules of thumb when using unless:
  # 
  # 1. Avoid using more than a single logical condition. unless foo? 
  #    is fine. unless foo? && bar? is harder to parse.
  # 2. Avoid negation. ÒUnlessÓ is already negative. Piling more on 
  #    only makes it worse.
  # 3. Never, ever, ever use an else clause with an unless statement.
  # 
  # http://37signals.com/svn/posts/2699-making-sense-with-rubys-unless
  # http://railstips.org/blog/archives/2008/12/01/unless-the-abused-ruby-conditional/
  # 

  def test_unless_statement
    result = :default_value
    unless false    # same as saying 'if !false', which evaluates as 'if true'
      result = :false_value
    end
    assert_equal :false_value, result
  end

  def test_unless_statement_evaluate_true
    result = :default_value
    unless true    # same as saying 'if !true', which evaluates as 'if false'
      result = :true_value
    end
    assert_equal :default_value, result
  end

  def test_unless_statement_modifier
    result = :default_value
    result = :false_value unless false

    assert_equal :false_value, result
  end

  def test_while_statement
    i = 1
    result = 1
    while i <= 10
      result = result * i
      i += 1
    end
    assert_equal 3628800, result
  end

  def test_break_statement
    i = 1
    result = 1
    while true
      break unless i <= 10
      result = result * i
      i += 1
    end
    assert_equal 3628800, result

    # !!!!!!!!!!!!!!!!!!!!!!!!
    # If i isn't <= 10, then break the while loop
  end

  def test_break_statement_returns_values
    i = 1
    result = while i <= 10
      break i if i % 2 == 0
      i += 1
    end

    assert_equal 2, result
  end

  def test_next_statement
    i = 0
    result = []
    while i < 10
      i += 1
      next if (i % 2) == 0
      result << i
    end
    assert_equal [1, 3, 5, 7, 9], result

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     # The next keyword is the equivalent of the continue keyword in other 
    # languages.
    # next will enter the next iteration without further evaluation skipping the append to the result array code.
    # The next if statement will skip even numbers. 
    # Reminder: 
    # using << will append (push) elements in the result array.
  end

  def test_for_statement
    array = ["fish", "and", "chips"]
    result = []
    for item in array
      result << item.upcase
    end
    assert_equal ["FISH", "AND", "CHIPS"], result
  end

  def test_times_statement
    sum = 0
    10.times do
      sum += 1
    end
    assert_equal 10, sum
  end

end
