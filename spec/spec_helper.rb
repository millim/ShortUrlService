ENV['RACK_ENV'] = 'test'


require File.expand_path('../../config/application', __FILE__)


require 'ffaker'
require 'rack/test'
KEY_LENGTH = 6
KEY_HOST = 'http://localhost'

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))


RSpec.configure do |config|
  config.color = true
  config.include Rack::Test::Methods
  config.raise_errors_for_deprecations!
  config.before(:each) { Grape::Util::InheritableSetting.reset_global! }


  # use Rack::Config do |env|
  #   env['api.tilt.root'] = File.expand_path('../../app/views', __FILE__)
  # end

  # FactoryGirl.find_definitions


  config.after(:all) do
    Mongoid.purge!
  end
end

