use Rack::ShowExceptions
require File.expand_path('../config/application', __FILE__)
require 'rack/cors'

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::DEBUG


puts "默认地址为： http://localhost:9292"
at_exit { p "结束!!!"}

run Start.instance
