class SendFriendRequestTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:b) # Use a fixture user
        @user2 = users(:c) # Use a fixture user
    end

    test 'can send a friend request' do
        visit "/auth"
        fill_in "identifier_login_field", with: @user2.username
        fill_in "password_login_field", with: "a1"
        
        click_button 'login_button'
        click_link 'toSquare3'
        click_link 'add-friend-link'
        fill_in "users-search", with: @user.username

        # Find button by custom attribute 'data-user-id'
        user_button = find("button[data-user-id='#{@user.id}']")
        assert user_button.present?, "Button with data-user-id should be present"
        user_button.click
        click_link "back"
        click_link "Inviate"

        # Assert that there is an h3 element containing @user.username within the list with id 'users-list'
        within("#users-list") do
        assert_selector("h3", text: @user.username)
        end

    end
end