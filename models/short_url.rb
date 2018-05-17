class ShortUrl
  include Mongoid::Document
  include Mongoid::Timestamps

  field :original_url, type: String  #原始url
  field :key,          type: String  #生成的key
  field :key_length,   type: Integer

  field :use_count,    type: Integer, default: 0 #调用次数

  # field :create_ip_address, type: String

  index({original_url: 1})
  index({key: -1})
  index({key_length: -1, key: 1})


  #获取key的url
  def key_url
    "#{KEY_HOST}/#{self.key}"
  end

  def show
    {
        url: self.original_url,
        key: self.key,
        use_count: self.use_count,
        created_at: self.created_at
    }
  end


  #根据key查找url
  def self.find_url_by_key(key)
    su = ShortUrl.where(key: key, key_length: key.length).first
    return nil if su.blank?
    su.inc(use_count: 1)
    su.original_url
  end

  # 根据url创建短链接
  def self.create_short_url(url, manual_key = nil)
    _short_url = ShortUrl.where(original_url: url).first
    manual_key = nil if manual_key.blank?
    return _short_url.key_url if _short_url && manual_key == nil
    _short_url = manual_key.nil? ? create_key_url(url) : manual_create_key_url(url, manual_key)
    _short_url.key_url
  end


  private


  #创建一个短链接，并存入数据库
  def self.create_key_url(url, _key = nil)
    _key ||= KeyRedis.get_key
    _short_url = ShortUrl.find_or_create_by  key: _key, key_length: _key.length
    _short_url.original_url = url
    _short_url.use_count = 0
    _short_url.save
    _short_url
  end

  #验证指定key并根据key生成url
  def self.manual_create_key_url(url, key)
    _short_url = ShortUrl.where(key: key, key_length: key.length).first
    if _short_url
      return nil unless CAN_COVER
      modify_url_by_key(url, _short_url)
    else
      _short_url = create_key_url(url, key)
    end
    _short_url
  end


  #更新指定key的url
  def self.modify_url_by_key(url, _short_url)
    _short_url.update!(original_url: url)
  end








end