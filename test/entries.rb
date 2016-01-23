require 'minitest/autorun'
require 'keepass'
require_relative 'common'

class TestKeepass_Entries < Minitest::Test
    def test_time_methods
        kdb   = Keepass::Database.open KP_FILE, CORRECT_PASSWORD
        entry = kdb.entries[0]

        times = TIME_METHODS.collect do |method|
            (entry.send method).class
        end

        assert_equal times, [ Time ] * TIME_METHODS.length
    end
end
