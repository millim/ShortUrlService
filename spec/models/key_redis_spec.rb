require 'spec_helper'

describe KeyRedis, type: :model do

  describe 'KeyRedis#create_key' do
    it '创建一个key, 同时更新长度' do
      key_redis = KeyRedis.create

      _key = key_redis.create_key
      expect(_key).to eq '000001'

      key_redis.key_length = 5
      _key = key_redis.create_key
      expect(_key).to eq '00002'

      key_redis.key_length = 4
      _key = key_redis.create_key
      expect(_key).to eq '0003'
    end
  end

  describe 'KeyRedis.get_key' do
    it '获取key' do

      _key_8bit = KeyRedis.get_key(8)
      expect(_key_8bit).to eq '00000001'

      _key_8bit = KeyRedis.get_key(8)
      expect(_key_8bit).to eq '00000002'

      _key_4bit = KeyRedis.get_key(4)
      expect(_key_4bit).to eq '0001'

      _key_4bit = KeyRedis.get_key(4)
      expect(_key_4bit).to eq '0002'

      _key_1bit = KeyRedis.get_key(1)
      expect(_key_1bit).to eq '1'

      #32位，去除0,去除下面即将取的最后一位，再去除前面key位1生成的值
      (32 - 1 - 1 - 1).times {KeyRedis.get_key(1)}
      _key_1bit = KeyRedis.get_key(1)
      expect(_key_1bit).to eq 'v'
    end

    it 'key结束一轮后，重新从首位开始使用' do
      keys = []

      31.times{keys << KeyRedis.get_key(1)}
      _val = (1..9).to_a.map(&:to_s)+('a'..'v').to_a
      expect(keys).to eq _val

      keys << KeyRedis.get_key(1)
      _val << '1'

      expect(keys).to eq _val
    end
  end






end