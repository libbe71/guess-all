# spec/rails_helper.rb
Capybara.configure do |config|
    config.ignore_hidden_elements = true
    config.default_driver = :selenium
  end