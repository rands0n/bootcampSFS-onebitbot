require_relative '../app'
require 'rspec'
require 'rack/test'
require 'ffaker'
require 'pg_search'

Dir['./spec/support/**/*.rb'].each { |file| require file }
Dir['./app/services/**/*.rb'].each { |file| require file }

set :environment, :test

module RSpecMixin
  include Rack::Test::Methods

  def app
    App
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  ActiveRecord::Base.logger = nil unless ENV['LOG'] == true
end
