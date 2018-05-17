require 'uri'
class ShortUrlApi < Grape::API
  content_type :json, 'application/json'
  format :json

  desc '短链详情列表'
  params do
    # requires :password, type: String, module: Md5, desc: '采用密码'
    optional :page, type: Integer, default: 1
    optional :per,  type: Integer,  default: 10
  end
  get '/u' do
    params[:page] = 1 if  params[:page] <= 0
    params[:per]  = 10 if  params[:per] <= 0

    skip_num = (params[:page]-1) * params[:per]
    _sus = ShortUrl.order(created_at: -1).skip(skip_num).limit(params[:per])
    {
        count: ShortUrl.count,
        short_url_list: _sus.map(&:show)
    }
  end

  desc '生成短链，为了方便使用'
  params do
    requires :url, type: String, desc: '原始长链'
    optional :set_short_url, type: String, desc: '希望的短链接'
  end
  post '/u' do

    unless params[:set_short_url].blank?
      params[:set_short_url] = params[:set_short_url].downcase
      error!('短链接长度不能超过8位', 401) if params[:set_short_url].length > 8

      %w{w x y z}.each do |char|
        error!('短链接不能包含 w,x,y,z', 401) if params[:set_short_url].include? char
      end

      _short_url = ShortUrl.where(key: params[:set_short_url], key_length: params[:set_short_url].length).first

      error!('此短链接以被使用', 401) if _short_url && !CAN_COVER
    end

    error!('请填入正确的链接，以 http 或 https 开头', 401) unless params[:url] =~ URI::regexp

    key_url = ShortUrl.create_short_url params[:url], params[:set_short_url]

    {
        short_url: key_url
    }
  end

  desc '短链详情'
  params do
    requires :key, type: String, desc: '短链key'
  end
  get '/u/:key/info' do
    error!('Not Found', 404) if params[:key].length >8
    _short_url = ShortUrl.where(key: params[:key], key_length: params[:key].length).first
    error!('Not Found', 404) if _short_url.nil?
    _short_url.show
  end





end