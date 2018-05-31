# 为了方便，强制develement模式
ENV['RACK_ENV'] ||= 'development'
ENV['MONGOID_ENV'] = ENV['RACK_ENV']

# config load path
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'

require 'initialization'
Bundler.require :default, ENV['RACK_ENV']


#加载全局配置配置
CONFIG_YML = YAML.load_file("#{File.dirname(__FILE__)}/application.yml")

KEY_LENGTH = CONFIG_YML['key_length']
KEY_HOST   = CONFIG_YML['key_host']
CAN_COVER  = CONFIG_YML['can_cover']
BLANK_KEY_URL  = CONFIG_YML['blank_key_url']

addDirsToLoadPath   '../models','../api', '../run'


#加载mongodb配置
Mongoid.load!("#{File.dirname(__FILE__)}/mongoid.yml")

Mongo::Logger.logger.level = Logger::ERROR
Mongoid.logger.level = Logger::ERROR

Mongoid::Tasks::Database.create_indexes



