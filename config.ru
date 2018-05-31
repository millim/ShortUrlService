use Rack::ShowExceptions
require File.expand_path('../config/application', __FILE__)
require 'rack/cors'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::DEBUG
run Start.instance
