require 'test_helper'

class UserFinderTest < ActiveSupport::TestCase
  fixtures :all

  def test_find_all_by_default
    finder = UserFinder.new(users(:blue), 'search/a')
    assert_equal "a", finder.query_term
    assert_same_entities [users(:aaron)], finder.find
  end

  # We do not display a list of ALL users.
  # The list should either be limited to friends / peers or by a search.
  def test_no_list_of_all_users
    finder = UserFinder.new(users(:blue), 'search')
    assert_equal "", finder.query_term
    assert_same_entities [], finder.find
  end

  def test_find_contacts
    finder = UserFinder.new(users(:blue), 'contacts/')
    assert_equal "", finder.query_term
    visible_friends = users(:blue).friends.with_access(users(:blue) => :view)
    assert_same_entities visible_friends, finder.find
  end

  def test_find_peers
    finder = UserFinder.new(users(:blue), 'peers/')
    assert_equal "", finder.query_term
    visible_peers = users(:blue).peers.with_access(users(:blue) => :view)
    assert_same_entities visible_peers, finder.find
  end

  def assert_same_entities(expected, actual)
    assert expected == actual, <<-EOMESSAGE
      Expected #{expected.map(&:name).to_sentence}.
      Got #{actual.map(&:name).to_sentence}".
    EOMESSAGE
  end

end
