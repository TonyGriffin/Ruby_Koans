require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutStrings < Neo::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal true, string.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal "He said, \"Go Away.\"", string
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal "Don't", string
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal true, a == b
    assert_equal true, a == c
  end

  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %{
It was the best of times,
It was the worst of times.
}
    assert_equal 54, long_string.length
    assert_equal 3, long_string.lines.count
    assert_equal "\n", long_string[0,1]

  #  Is identical to:
  #  long_string = "\nIt was the best of times,\nIt was the worst of times.\n"

  # "\n" is the escape character representing a newline and newlines are preserved in multi-line strings.

  # .lines basically splits the string on newlines, but it doesn't care whether the string has a trailing newline or not, so "a\na" and "a\na\n" both have two lines as far as .lines is concerned.
  end

  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    assert_equal 53, long_string.length
    assert_equal 2, long_string.lines.count
    assert_equal "I", long_string[0,1]

    # !!!!!!!!!!!!!!!!!!!!!!!!!
    # Cant say I fully understand the syntax <<EOS...EOS , but 53 for .length is achieved due to the number of charachters, whitespace and also the implied \n for the new line.

    # There are only 2 lines, with the second line being created at the \n point in the sentence.

    # "I" is the first charachter.
  end

  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal "Hello, World", string
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = "Hello, "
    there = "World"
    string = hi + there
    assert_equal "Hello, ", hi
    assert_equal "World", there
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = "Hello, "
    there = "World"
    hi += there
    assert_equal "Hello, World", hi
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi += there
    assert_equal "Hello, ", original_string

     # using += doesn't change the original string object
  end

  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = "Hello, "
    there = "World"
    hi << there
    assert_equal "Hello, World", hi
    assert_equal "World", there

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Shovel operator << , this will append to the string, changing the string.
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi << there
    assert_equal "Hello, World", original_string

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?

    # when using << we are changing the object on the left hand side so since "hi" was set to a reference of the variable "original_string" therefore "original_string"s 
    # value now changes to contain whatever was being appended

    #  << alters the original string rather than creating a new one.  This results in efficient memory usage when dealing with large scale string manipulation.
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal 2, string.size
  end

  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\''
    assert_equal 2, string.size
    assert_equal "\\'", string

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # From WikiBooks:Ruby
    # Single quotes only support two escape sequences, ie: \ and '
    #  \' – single quote
    #  \\ – single backslash

    # Except for these two escape sequences, everything else between single quotes is treated literally.
    # Double quotes allow for many more escape sequences than single quotes. They also allow you to embed variables or Ruby code inside of a string literal – this is commonly referred to as interpolation.
  end

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # placeholder, the variable name goes within #{} and whenever that placeholder exists within £{}     in a double quoted string it is replaced with the value of the placholder variable.
    # requires double quotes!!
  end

  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal "The value is \#{value}", string

    # !!!!!!!!!!!!!!!!!!!!!!!!!
    # not sure why we have an escape sequence charachter \ before the   #{value}
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal "The square root of 5 is 2.23606797749979", string
  end

  def test_you_can_get_a_substring_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal "let", string[7,3]
    assert_equal "let", string[7..9]
  end

  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal "a", string[1]

    # Surprised?
  end

  in_ruby_version("1.8") do
    def test_in_older_ruby_single_characters_are_represented_by_integers
      assert_equal 97, ?a
      assert_equal true, ?a == 97

      assert_equal true, ?b == (?a + 1)
    end
  end

  in_ruby_version("1.9", "2") do
    def test_in_modern_ruby_single_characters_are_represented_by_strings
      assert_equal "a", ?a
      assert_equal false, ?a == 97
    end
  end

  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split
    assert_equal ["Sausage", "Egg", "Cheese"], words

    # !!!!!!!!!!!!!!!!!!!!!!!!!
    # .split method, creates an array containing the separated by whitespace components of the string
  end

  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    words = string.split(/:/)
    assert_equal ["the", "rain", "in", "spain"], words

    # !!!!!!!!!!!!!!!!!!!!!!!!!
    # .split method, creates an array containing components of the string separated by the chosen delimiter, in this case ":"

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"]
    assert_equal "Now is the time", words.join(" ")

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # An array of strings can be joined into one string with the .join() method.
  end

  def test_strings_are_unique_objects
    a = "a string"
    b = "a string"

    assert_equal true, a == b
    assert_equal false, a.object_id == b.object_id
  end
end
