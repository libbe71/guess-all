require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:b)
    @friend1 = users(:j)
    @friend2 = users(:g)
    @friend3 = users(:e)
    post "/auth/create_session", params: { auth:{identifier: @user.username, password: "a"} }
  end

  test "should veify the number of @games" do
    get "/it/user/#{@user.id}/games"
    assert_response :success
    games = @controller.instance_variable_get(:@games)
    assert_not_nil games, "@games should not be nil"
    assert_equal 34, games.count, "There should be exactly 34 accepted games"
    games.each do |game|
      assert game.player1_id == @user.id || game.player2_id == @user.id, "One of the users in the game should be @user"
    end
  end
end
