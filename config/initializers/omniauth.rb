#Rails.application.config.middleware.use OmniAuth::Builder do
# provider :developer if Rails.env.development?
#end

#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
#    scope: 'email,user_birthday,user_gender,user_hometown', display: 'popup', 
#    image_size: 'normal', user_info: 'first_name,last_name,email,birthday,genderhometown, '
#end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    scope: 'email,user_birthday,user_gender,user_hometown', 
    info_fields: 'email,birthday,first_name,gender,hometown,last_name,location'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
  scope: 'email,profile'
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTEER_API_KEY'], ENV["TWITTER_API_SECRET_KEY"]
end