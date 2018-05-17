class KeyRedis
  include Mongoid::Document

  field :key_length, type: Integer, default: 6   #key的长度
  field :counter, type: Integer, default: 0      #counter的值
  field :max_counter, type: Integer, default: 0


  REST_MESSAGE = 'this key is exists'.freeze

  before_create do
    raise 'key长度不允许大于8位' if key_length > 8
    raise 'key长度最少需要1位' if key_length <= 0
    self.max_counter = 32 ** self.key_length - 2
  end


  # params:
  #   ++key_length++ integer   key的长度
  # return:
  #   string
  def self.get_key(key_length = nil)
    key_length ||= KEY_LENGTH
    _key_redis = KeyRedis.find_or_create_by(key_length: key_length)
    _key_redis.create_key
  end


  def create_key

    begin
      _counter = _get_the_counter
      key      = _get_key_by_counter(_counter, self.key_length)
      _valid_key(key, self.key_length)
      key
    rescue => e
      if e.message == REST_MESSAGE
        retry
      end
      raise e
    end
  end

private

  #获取当前长度的最大值
  def _get_the_counter
    if self.counter <= self.max_counter
      self.inc(counter: 1)
    else
      self.update!(counter: 1)
      1
    end
    self.counter
  end


  #生成短链接
  def _get_key_by_counter(counter, length)
    counter.to_s(32).rjust(length,'0')
  end

  #验证链接是否使用
  def _valid_key(key, key_length)
    raise REST_MESSAGE if ShortUrl.where(key: key, key_length: key_length).exists?
  end









end