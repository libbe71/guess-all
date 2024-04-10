Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    scope: 'email,user_birthday,user_gender,user_hometown', display: 'popup', 
    image_size: 'normal', user_info: 'first_name,last_name,email,birthday,genderhometown, '
end