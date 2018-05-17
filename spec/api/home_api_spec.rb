
require 'ffaker'
require File.expand_path("#{APP_ROOT}/run/api", __FILE__)
describe HomeApi do

  def app
    Api.new
  end

  before do
    @url_1 = FFaker::Internet.http_url
  end

  describe 'get /:key' do
    it '通过key获取链接' do

      get '/000001'
      expect(last_response.status).to eq 404
      ShortUrl.create_short_url @url_1

      get '/000001'
      expect(last_response.status).to eq 302
      expect(last_response['Location']).to eq @url_1
    end
  end


end