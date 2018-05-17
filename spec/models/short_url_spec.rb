require 'spec_helper'
require 'ffaker'
describe ShortUrl, type: :model do

  before(:all) do
    @url_1 = FFaker::Internet.http_url
    @url_2 = FFaker::Internet.http_url
    @key_length = KEY_LENGTH
    @key_host = KEY_HOST
  end

  describe 'ShortUrl.create_short_url' do
    it '创建短链接' do
      ShortUrl.create_short_url @url_1
      val = '000001'

      short_url = ShortUrl.find_by key: val
      expect(short_url.key).to eq val
      expect(short_url.key_url).to eq "#{@key_host}/#{val}"
      expect(short_url.original_url).to eq @url_1
      expect(short_url.use_count).to eq 0
    end
  end

  describe 'ShortUrl.find_url_by_key' do
    it '根据key查找短链接' do
      key1 = '000001'
      key2 = '000002'

      url = ShortUrl.find_url_by_key key1
      expect(url).to eq @url_1

      url = ShortUrl.find_url_by_key key2
      expect(url).to be_nil

      ShortUrl.create_short_url @url_2
      url = ShortUrl.find_url_by_key key2
      expect(url).to eq @url_2
    end
  end



end