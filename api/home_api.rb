class HomeApi < Grape::API

  content_type :json, 'application/json'
  format :json

  desc '正常key访问'
  params do
    requires :key, type: String, desc: '一般key'
  end
  get '/:key' do
    error!('Not Found', 404) if params[:key].length >8
    params[:key] = params[:key].downcase
    url = ShortUrl.find_url_by_key params[:key]
    url.nil? ? error!('Not Found', 404) : redirect(url)
  end

  desc '跳转到html'
  get '/' do
    redirect('/views/index.html')
  end

end