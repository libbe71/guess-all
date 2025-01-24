require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:b) # Use a fixture user
    # Simulate login, adjust according to your custom authentication method
    post "/auth/create_session", params: { auth:{identifier: @user.username, password: "a"} }

    session[:user_id] = @user.id
  end


  test "should assign @friends with accepted requests" do
    get "/it/user/#{@user.id}/friends"
    # Assert response is successful
    assert_response :success

  
    # Debug the content of @friends
    friends = @controller.instance_variable_get(:@friends)
    
    # 12, 9, 2
    friend1 = users(:j) #12
    friend2 = users(:g) #9
    friend3 = users(:e) #2
    # Assertions
    assert_not_nil friends, "@friends should not be nil"
    assert_equal 3, friends.count, "There should be exactly 2 accepted friends"

    assert_includes friends, friend1, "friend1 should be in @friends"
    assert_includes friends, friend2, "friend2 should be in @friends"
    assert_includes friends, friend3, "friend3 should be in @friends"
  end
  
  
  

  # test "should create friend request" do
  #   assert_difference 'Friend.count', 1 do
  #     post create_friend_path, params: { friend: { friend_id: @friend.id } }
  #   end
  #   assert_redirected_to friend_path(@user.id)
  #   follow_redirect!
  #   assert_match 'request sent', flash[:notice]
  # end

  # test "should accept friend request" do
  #   Friend.create(user1_id: @user.id, user2_id: @friend.id, status: 'pending')

  #   post accept_friend_path, params: { friend: { friend_id: @friend.id } }
  #   assert_redirected_to friend_path(@user.id)
  #   follow_redirect!
  #   assert_match 'Friendship updated', flash[:notice]
  # end

  # test "should delete friend" do
  #   Friend.create(user1_id: @user.id, user2_id: @friend.id, status: 'accepted')

  #   assert_difference 'Friend.count', -1 do
  #     post delete_friend_path, params: { friend: { friend_id: @friend.id } }
  #   end
  #   assert_redirected_to friend_path(@user.id)
  #   follow_redirect!
  #   assert_match 'Friendship deleted', flash[:notice]
  # end

  # test "should index users with search query" do
  #   get index_users_friends_path, params: { search_query: @friend.username }
  #   assert_response :success
  #   assert_match @friend.username, @response.body
  # end

  # test "should index accepted friends with search query" do
  #   Friend.create(user1_id: @user.id, user2_id: @friend.id, status: 'accepted')

  #   get index_friends_friends_path, params: { search_query: @friend.username }
  #   assert_response :success
  #   assert_match @friend.username, @response.body
  # end

  # test "should return search results for sent requests" do
  #   Friend.create(user1_id: @user.id, user2_id: @friend.id, status: 'pending')

  #   get search_sent_friends_path, params: { search_query: @friend.username }
  #   assert_response :success
  #   assert_match @friend.username, @response.body
  # end

  # test "should return search results for received requests" do
  #   Friend.create(user1_id: @friend.id, user2_id: @user.id, status: 'pending')

  #   get search_received_friends_path, params: { search_query: @friend.username }
  #   assert_response :success
  #   assert_match @friend.username, @response.body
  # end

  # test "should search users excluding current user and friends" do
  #   get search_users_friends_path, params: { search_query: 'new_user' }
  #   assert_response :success
  #   assert_match 'new_user', @response.body
  # end
end
