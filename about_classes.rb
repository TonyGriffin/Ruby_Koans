require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClasses < Neo::Koan
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    fido = Dog.new
    assert_equal Dog, fido.class
  end

  # ------------------------------------------------------------------

  class Dog2
    def set_name(a_name)
      @name = a_name
    end
  end

  def test_instance_variables_can_be_set_by_assigning_to_them
    fido = Dog2.new
    assert_equal [], fido.instance_variables

    fido.set_name("Fido")
    assert_equal [:@name], fido.instance_variables
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

    assert_raise(Exception) do
      fido.name
    end

    assert_raise(SyntaxError) do
      eval "fido.@name"
      # NOTE: Using eval because the above line is a syntax error.
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.instance_variable_get("@name")
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.instance_eval("@name")  # string version
    assert_equal "Fido", fido.instance_eval { @name } # block version
  end

  # ------------------------------------------------------------------

  class Dog3
    def set_name(a_name)
      @name = a_name
    end
    def name
      @name
    end
  end

  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog4
    attr_reader :name

    def set_name(a_name)
      @name = a_name
    end
  end


  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog5
    attr_accessor :name
  end


  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new

    fido.name = "Fido"
    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog6
    attr_reader :name
    def initialize(initial_name)
      @name = initial_name
    end
    # Initialize has a required argument of name
  end

  def test_initialize_provides_initial_values_for_instance_variables
    fido = Dog6.new("Fido")
    assert_equal "Fido", fido.name
  end

  def test_args_to_new_must_match_initialize
    assert_raise(ArgumentError) do
      Dog6.new
    end
    # THINK ABOUT IT:
    # Why is this so?

    # The initialize method is called whenever an object is created using the new method.

    # From RubyDoc:
    # The new method calls the allocate method to create a new object of class’s class, then invokes that object’s initialize method, passing it args. This is the method that ends up getting called whenever an object is constructed using .new
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    assert_equal true, rover.name != fido.name
  end

  # ------------------------------------------------------------------

  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end

    def get_self
      self
    end

    def to_s
      @name
    end

    def inspect
      "<Dog named '#{name}'>"
      # Returns a string containing a human-readable representation of obj. The default inspect shows the object’s class name, an encoding of the object id, and a list of the instance variables and their values (by calling inspect on each of them). User defined classes should override this method to provide a better representation of obj. When overriding this method, it should return a string whose encoding is compatible with the default external encoding.
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")

    fidos_self = fido.get_self
    assert_equal fido, fidos_self

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # NOTE: Not sure why its giving you the clue that the answer is the return of the classes inspect method??
    # When the answer would seem to be that you are comparng the object to its "self" attribute.

    # The inspect function is what is analyzed when the self is analyzed to test for
    # equality. However, in the above code, it's referring to the object.
  end

  def test_to_s_provides_a_string_version_of_the_object
    fido = Dog7.new("Fido")
    assert_equal "Fido", fido.to_s
  end

  def test_to_s_is_used_in_string_interpolation
    fido = Dog7.new("Fido")
    assert_equal "My dog is Fido", "My dog is #{fido}"

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # The to_s method returns either the user defined explanation for the class or else the default if user didnt rewrite the body of the  to_s method.
  end

  def test_inspect_provides_a_more_complete_string_version
    fido = Dog7.new("Fido")
    assert_equal "<Dog named 'Fido'>", fido.inspect
  end

  def test_all_objects_support_to_s_and_inspect
    array = [1,2,3]

    assert_equal "[1, 2, 3]", array.to_s
    assert_equal "[1, 2, 3]", array.inspect

    assert_equal "STRING", "STRING".to_s
    assert_equal "\"STRING\"", "STRING".inspect
  end

end
