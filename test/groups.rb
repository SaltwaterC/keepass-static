require 'minitest/autorun'
require 'keepass'
require 'keepass-methods'
require_relative 'common'

class TestKeepassGroups < Minitest::Test
  def setup
    @kdb = Keepass::Database.open KP_FILE, CORRECT_PASSWORD
  end

  def test_group_names
    seen_groups = []

    @kdb.groups.each do |group|
      seen_groups << group.name
    end

    assert_equal seen_groups, %w(Test1 Test2 Test2)
  end

  def test_time_methods(group = nil)
    group = @kdb.groups[0] if group.nil?

    times = TIME_METHODS.collect do |method|
      (group.send method).class
    end

    assert_equal times, [Time] * TIME_METHODS.length
  end

  def test_entries(group = nil)
    group = @kdb.groups[0] if group.nil?

    assert_equal seen_entries(group.entries), [
      { name: 'Test1', password: '12345' },
      { name: 'Test2', password: 'abcde' }
    ]
  end

  def test_group_method
    group = @kdb.group 'Test1'
    test_time_methods group
    test_entries group

    assert_equal @kdb.group('Test3'), nil

    @kdb.group 'Test2'
  rescue RuntimeError => e
    assert_equal e.message, 'Error: found multiple groups with name Test2'
  end

  private

  def seen_entries(entries)
    ent = []

    entries.each do |entry|
      ent << { name: entry.name, password: entry.password }
    end

    ent.sort! do |a, b|
      a[:name] <=> b[:name]
    end

    ent
  end
end
