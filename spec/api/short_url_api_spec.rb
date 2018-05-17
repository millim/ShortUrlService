require 'ffaker'
require File.expand_path("#{APP_ROOT}/run/api", __FILE__)
describe ShortUrlApi do

  def app
    Api.new
  end

  before(:all) do
    @url_1 = FFaker::Internet.http_url
    @url_2 = FFaker::Internet.http_url
    @url_3 = "https://#{FFaker::Youtube.url}"
    @manual_key = '2c5ibe'
  end

  describe 'get /u/:url' do
    it '生成短链接' do
      post '/u', {url: @url_1}
      expect(last_response.status).to eq 201
      body = JSON.parse(last_response.body)
      expect(body['short_url']).to eq "#{KEY_HOST}/000001"
    end

    it '根据生成的key获取原始url' do
      get '/000001'
      expect(last_response.status).to eq 302
      expect(last_response['Location']).to eq @url_1
    end

    it '将url设置为指定key' do
      post '/u', {url: @url_2, set_short_url: @manual_key}
      expect(last_response.status).to eq 201
      body = JSON.parse(last_response.body)
      expect(body['short_url']).to eq "#{KEY_HOST}/#{@manual_key}"
    end

    it '根据生成的key获取原始url' do
      get "/#{@manual_key}"
      expect(last_response.status).to eq 302
      expect(last_response['Location']).to eq @url_2
    end
  end

  describe 'get /u/:key/info' do

    it '查看未生成的数据' do
      get '/u/123456/info'
      expect(last_response.status).to eq 404
      get '/u/222/info'
      expect(last_response.status).to eq 404
    end

    it '根据生成的key获取原始url' do
      get '/u/000001/info'
      expect(last_response.status).to eq 200
      body = JSON.parse(last_response.body)

      expect(body['url']).to_not be_nil
      expect(body['key']).to_not be_nil
      expect(body['use_count']).to_not be_nil
      expect(body['created_at']).to_not be_nil
    end
  end

  describe 'get /u' do
    it '获取短链接列表' do
      get '/u'
      expect(last_response.status).to eq 200
      body = JSON.parse(last_response.body)
      expect(body['count']).to_not be_nil
      expect(body['short_url_list']).to_not be_nil

      expect(body['count']).to eq 2
      expect(body['short_url_list'].length).to eq 2
    end
    it '获取短链接列表,一页一个' do
      get '/u?page=1&per=1'
      body = JSON.parse(last_response.body)
      expect(body['count']).to_not be_nil
      expect(body['short_url_list']).to_not be_nil

      expect(body['count']).to eq 2
      expect(body['short_url_list'].length).to eq 1
    end
  end




end