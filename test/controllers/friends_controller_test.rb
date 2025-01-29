require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:b)
    @user2 = users(:c)
    @friend1 = users(:j)
    @friend2 = users(:g)
    @friend3 = users(:e)
    post "/auth/create_session", params: { auth:{identifier: @user.username, password: "a"} }
  end

  test "should assign @friends with accepted requests" do
    get "/it/user/#{@user.id}/friends"
    assert_response :success
    friends = @controller.instance_variable_get(:@friends)
    assert_not_nil friends, "@friends should not be nil"
    assert_equal 3, friends.count, "There should be exactly 2 accepted friends"
    assert_includes friends, @friend1, "friend1 should be in @friends"
    assert_includes friends, @friend2, "friend2 should be in @friends"
    assert_includes friends, @friend3, "friend3 should be in @friends"
  end  
end