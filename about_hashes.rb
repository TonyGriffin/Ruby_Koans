require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutHashes < Neo::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal "uno", hash[:one]
    assert_equal "dos", hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  def test_accessing_hashes_with_fetch
    hash = { :one => "uno" }
    assert_equal "uno", hash.fetch(:one)
    assert_raise(Exception) do
      hash.fetch(:doesnt_exist)
    end

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?

# Possible explanation:
    # By default, using #[] will retrieve the hash value if it exists, and return nil if it doesn't exist *.

# Using #fetch gives you a few options (see the docs on #fetch):

# fetch(key_name): get the value if the key exists, raise a KeyError if it doesn't
# fetch(key_name, default_value): get the value if the key exists, return default_value otherwise
# fetch(key_name) { |key| "default" }: get the value if the key exists, otherwise run the supplied block and return the value.
# Each one should be used as the situation requires, but #fetch is very feature-rich and can handle many cases depending on how it's used. For that reason I tend to prefer it over accessing keys with #[].

# Accessing a key with #[] will call #default_proc if it exists, or else return #default, which defaults to nil

# http://ruby-doc.org/core-1.9.3/Hash.html#method-i-fetch
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => "eins", :two => "dos" }
    assert_equal expected, hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?

    # Possible Answer:
    # Perhaps because otherwise you would have to compare each of the keys of hash and expected individually one by one? 
    # eg: hash[:one] == expected[:one]
  end

  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
  end

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert_equal Array, hash.keys.class
  end

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
  end

  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal true, hash != new_hash

    expected = { "jim" => __, "amy" => 20, "dan" => __, "jenny" => __ }
    assert_equal false, expected == new_hash
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal 1, hash1[:one]
    assert_equal nil, hash1[:two]

    hash2 = Hash.new("dos")
    hash2[:one] = 1

    assert_equal 1, hash2[:one]
    assert_equal "dos", hash2[:two]
    
    # In hash1, hash is initialised without a key/value. It is then assigned a key and given a value of 1.
    # in hash2, hash is initialised with an initil value in the new constuctor... "dos".
    # Then the first place in the hash is reassigned to the value 1, making the default value of "dos", the second value in the hashmap.
  end

  def test_default_value_is_the_same_object
    hash = Hash.new([])

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ["uno", "dos"], hash[:one]
    assert_equal ["uno", "dos"], hash[:two]
    assert_equal ["uno", "dos"], hash[:three]

    assert_equal true, hash[:one].object_id == hash[:two].object_id

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Not sure on this one, does << mean append to?

  end

  def test_default_value_with_block
    hash = Hash.new {|hash, key| hash[key] = [] }

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ["uno"], hash[:one]
    assert_equal ["dos"], hash[:two]
    assert_equal [], hash[:three]

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Not sure on this one, look up default value.
  end
end
