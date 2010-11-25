require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutSymbols < EdgeCase::Koan
  def test_symbols_are_symbols
    symbol = :ruby
    assert_equal true, symbol.is_a?(Symbol)
  end

  def test_symbols_can_be_compared
    symbol1 = :a_symbol
    symbol2 = :a_symbol
    symbol3 = :something_else

    assert symbol1 == symbol2
    assert symbol1 != symbol3
  end

  def test_identical_symbols_are_a_single_internal_object
    symbol1 = :a_symbol
    symbol2 = :a_symbol

    assert_equal true, symbol1           == symbol2
    assert_equal true, symbol1.object_id == symbol2.object_id
  end

  def test_method_names_become_symbols
    all_symbols = Symbol.all_symbols
    assert_equal true, all_symbols.include?(:test_method_names_become_symbols)
  end

  # THINK ABOUT IT:
  #
  # Why do we capture the list of symbols before we check for the
  # method name?
  # 
  # A: Because we want to test that a method contains the method
  # as a symbol without actually declaring it. If we do the following:
  # 
  # assert_equal true, :test_method_names_become_bogus.is_a?(Symbol)
  # 
  # we're not actually verifying that the method exists in Ruby's symbol table
  # because we're creating the symbol within the assertion itself.
  
  
  in_ruby_version("mri") do
    RubyConstant = "What is the sound of one hand clapping?"
    def test_constants_become_symbols
      all_symbols = Symbol.all_symbols

      assert_equal true, all_symbols.include?(:RubyConstant)
    end
  end

  def test_symbols_can_be_made_from_strings
    string = "catsAndDogs"
    assert_equal :catsAndDogs, string.to_sym
  end

  def test_symbols_with_spaces_can_be_built
    symbol = :"cats and dogs"

    assert_equal symbol, symbol.to_sym
  end

  def test_symbols_with_interpolation_can_be_built
    value = "and"
    symbol = :"cats #{value} dogs"

    assert_equal symbol, symbol.to_sym
  end

  def test_to_s_is_called_on_interpolated_symbols
    symbol = :cats
    string = "It is raining #{symbol} and dogs."

    assert_equal "It is raining #{:cats} and dogs.", string
  end

  def test_symbols_are_not_strings
    symbol = :ruby
    assert_equal false, symbol.is_a?(String)
    assert_equal false, symbol.eql?("ruby")
  end

  def test_symbols_do_not_have_string_methods
    symbol = :not_a_string
    assert_equal false, symbol.respond_to?(:each_char)
    assert_equal false, symbol.respond_to?(:reverse)
  end

  # It's important to realize that symbols are not "immutable
  # strings", though they are immutable. None of the
  # interesting string operations are available on symbols.

  def test_symbols_cannot_be_concatenated
    # Exceptions will be pondered further father down the path
    assert_raise(NoMethodError) do
      :cats + :dogs
    end
  end

  def test_symbols_can_be_dynamically_created
    assert_equal :catsdogs, ("cats" + "dogs").to_sym
  end

  # THINK ABOUT IT:
  #
  # Why is it not a good idea to dynamically create a lot of symbols?
  #
  # Unlike most other objects in Ruby, symbols are not garbage collected
  # and stay in Ruby's memory for the duration of the program's operation.
  #
  # From a usability standpoint, the usefulness of symbols is obvious when
  # we see that several places in the program need an immutable form
  # of the same string (e.g. :get, :post, :hello, :foo); in this case, we save
  # ourselves the cost of creating a new object everytime we need some that is 
  # immutable. To do this thoughtlessly will clutter up the Ruby heap and keep
  # the GC from freeing that memory up.
  
end
