require 'minitest/autorun'
require 'keepass'
require_relative 'common'

class TestKeepassOpen < Minitest::Test
  def assert_no_exception
    yield
    pass
  rescue StandardError => e
    flunk "Unexpected exception: #{e}"
  end

  def assert_exception(ex_type)
    yield
    flunk 'No exception was seen'
  rescue ex_type
    pass
  rescue StandardError => e
    flunk "Unexpected exception: #{e}"
  end

  def test_open_string_ok
    OPEN_METHODS.each do |method|
      assert_no_exception do
        Keepass::Database.send method, KP_FILE, CORRECT_PASSWORD
      end
    end
  end

  def test_open_file_ok
    OPEN_METHODS.each do |method|
      f = File.open(KP_FILE, 'rb')

      assert_no_exception do
        Keepass::Database.send method, f, CORRECT_PASSWORD
      end
    end
  end

  def test_open_string_with_bad_password
    OPEN_METHODS.each do |method|
      assert_exception Keepass::DecryptDataException do
        Keepass::Database.send method, KP_FILE, INCORRECT_PASSWORD
      end
    end
  end

  def test_open_file_with_bad_password
    OPEN_METHODS.each do |method|
      f = File.open(KP_FILE, 'rb')

      assert_exception Keepass::DecryptDataException do
        Keepass::Database.send method, f, INCORRECT_PASSWORD
      end
    end
  end
end
