require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
  add_filter 'mailer'
  add_filter 'job'
  add_filter 'helper'
  add_filter 'channel'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
require 'simplecov'

#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

SimpleCov.start

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of orders output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical orders.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
        provider: user.provider,
        uid: user.uid,
        info: {
            email: user.email,
        }
    }
  end

  def perform_login(user = nil)
    user ||= User.first

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get omniauth_callback_path(:github)

    expect(session[:user_id]).must_equal user.id

    return user
  end

  def current_merchant
    if session[:user_id]
      @current_merchant = Merchant.find_by(id: session[:user_id])
    end
  end
end
