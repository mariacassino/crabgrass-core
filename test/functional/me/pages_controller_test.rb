require_relative '../test_helper'

class Me::PagesControllerTest < ActionController::TestCase
  fixtures :users, :pages, 'user/participations', 'page/terms'

  def test_get_index_view
    login_as users(:blue)
    get :index
    assert_response :success
  end

  def test_list_pages
    login_as users(:blue)
    xhr :post, :index
    assert !assigns(:pages).empty?, "blue should have some pages to render"
    assert_response :success
  end

  def test_empty_list
    user = FactoryGirl.create :user
    login_as user
    xhr :post, :index
    assert assigns(:pages).empty?
    assert_response :success
  end

  def test_filter_by_own_pages
    login_as users(:blue)
    xhr :post, :index, add: "owned-by-me"
    assert_response :success
    assert pages = assigns(:pages)
    assert pages.any?
    assert_nil pages.detect{|page| page.owner != users(:blue)}
  end

  def test_filter_by_created_by_me
    login_as users(:blue)
    xhr :post, :index, add: "created-by-me"
    assert_response :success
    assert pages = assigns(:pages)
    assert !pages.empty?, "blue should have some own pages to render"
    assert_nil pages.detect{|page| page.created_by != users(:blue)}
  end

  def test_list_page_with_long_title
    title = 'VeryLongTitleWithNoSpaceThatWillBeFarTooLongToFitIntoTheTableColumnAndInTurnBreakTheLayoutUnlessItIsBrokenUsingHiddenHyphens'
    expected = json_escape('VeryLongTitleWithNoS&shy;paceThatWillBeFarToo&shy;LongToFitIntoTheTabl&shy;eColumnAndInTurnBrea&shy;kTheLayoutUnlessItIs&shy;BrokenUsingHiddenHyp&shy;hens')
    page = FactoryGirl.build :wiki_page, title: title, owner: users(:blue)
    Page.expects(:paginate_by_path).returns([page])
    login_as users(:blue)
    xhr :get, :index
    assert_response :success
    assert assigns(:pages).include?(page)
    assert response.body.include?(expected), "Expected #{response.body} to include #{expected}."
  end

end
