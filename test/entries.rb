require 'minitest/autorun'
require 'keepass'
require 'keepass-methods'
require_relative 'common'

class TestKeepassEntries < Minitest::Test
  def setup
    @kdb = Keepass::Database.open KP_FILE, CORRECT_PASSWORD
  end

  def test_time_methods(entry = nil)
    entry = @kdb.entries[0] if entry.nil?

    times = TIME_METHODS.collect do |method|
      (entry.send method).class
    end

    assert_equal times, [Time] * TIME_METHODS.length
  end

  def test_description_method
    entry = @kdb.entries[2]

    assert_equal entry.description, 'test.txt'
  end

  def test_data_method
    entry = @kdb.entries[2]

    assert_equal entry.data, "Test4\n"
  end

  def test_entry_method
    test_time_methods @kdb.entry('Test1')
    test_time_methods @kdb.entry('Test1', 'Test1')

    assert_equal @kdb.entry('Test5'), nil
    assert_equal @kdb.entry('Test5', 'Test3'), nil

    @kdb.entry 'Test4'
  rescue RuntimeError => e
    assert_equal e.message, 'Error: found multiple entries with title Test4'
  end
end
