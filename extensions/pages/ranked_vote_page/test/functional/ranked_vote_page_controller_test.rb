require 'test_helper'

class RankedVotePageControllerTest < ActionController::TestCase
  fixtures :pages, :users, 'user/participations', :polls, :possibles

  def setup
    user = users(:orange)
    login_as user
    @page = FactoryGirl.create :ranked_vote_page, created_by: user
    @poll = @page.data
  end

  def test_show_empty_redirects
    get :show, id: @page.id
    assert_response :redirect
    assert_redirected_to @controller.send(:page_url, @page, action: :edit)
  end

  def test_show_with_possible
    @poll.possibles.create do |pos|
      pos.name = "new option"
    end
    get :show, id: @page.id
    assert_response :success
    assert_template 'ranked_vote_page/show'
  end

  def test_edit
    get :edit, id: @page
    assert_response :success
  end

  # TODO: tests for sort, update_possible, edit_possible, destroy_possible,
end
