require File.expand_path(File.dirname(__FILE__) + '/neo')

C = "top level"

class AboutConstants < Neo::Koan

  C = "nested"

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal "nested", C
  end

  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal "top level", ::C

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # Careful, the top level C constant is 
  # defined outside the class but in this file, its still global.
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal "nested", AboutConstants::C
    assert_equal "nested", ::AboutConstants::C

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # Regarding the previous comment I  
  # was expecting this to be "top 
  # level" but that's a global constant, here we are referencing the 
  # C constant within the class. I missed that distinction at first.

  end

  # ------------------------------------------------------------------

  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end

    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------------------------------------------------

  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------

  class MyAnimals
    LEGS = 2

    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?

  # The Lexical scope

  # Answer
  # From StackOverflow:
  #     Ruby searches for the constant definition in this order:
  #       The enclosing scope
  #       Any outer scopes (repeat until top level is reached)
  #       Included modules
  #       Superclass(es)
  #       Object
  #       Kernel
  #     Refer this for more:
  #     http://coderrr.wordpress.com/2008/03/11/constant-name-resolution-in-ruby/

 #  ------------------------------------------------------------------

  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end

  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?

  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # Answer:
  # Bird is declared in the scope of MyAnimals, which has a higher precedence when resolving constants. Oyster is in the MyAnimals namespace, but it is not declared in that scope.
end
