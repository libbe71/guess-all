ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'capybara/rails'
require 'capybara/minitest'

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  Capybara.server = :puma
  Capybara.server_port = 55064
  Capybara.app_host = "http://127.0.0.1:55064/it"
  Capybara.default_driver = :selenium_chrome

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end