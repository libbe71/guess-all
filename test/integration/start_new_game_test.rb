class StartNewGameTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:b)
    @friend = users(:j)
  end

  test 'can send a friend request' do
    visit "/auth"
    fill_in "identifier_login_field", with: @user.username
    fill_in "password_login_field", with: "a"
    click_button 'login_button'
    click_link 'toSquare1'
    click_link "Inizia una nuova partita"
    user_button = find("button[data-user-id='#{@friend.id}']")
    assert user_button.present?, "Button with data-user-id should be present"
    user_button.click
    find("div#id-card-aldo").click
    click_button "confirmYes"
    click_link "back"
    within("#ongoing-games ul") do
      assert_selector("a", count: 35)
    end
  end
end